class MentionsController < ApplicationController

  include M2tUtil

  attr_accessor :screen_name
  before_filter :authenticate!, :only => [:search]
  
  def initialize;
    super
  end

  # public endpoints -------------------------------------------------------------------
  def search
    return unless valid_search_params?
    @screen_name = params[:screen_name]
    data = session.clone
    data.delete(:session_id)

    return false unless track_screen_name

    output = {
      "success"     => "Tracked #{screen_name}!",
      "pm_tool:"    => params[:pm_tool],
      "screen_name" => screen_name,
      "#{pm_tool}"  => {
          'auth' => data["#{params[:pm_tool]}"],
          'user' => pm_tool_api.me
      },
      "twitter" => { 'auth' => twitter_auth }
    }

    render :json => output
    return false
  end

  def posted_search
    return unless valid_search_params?
    redirect_to start_streaming_url({
      :pm_tool      => params[:pm_tool], 
      :screen_name  => params[:screen_name] 
    })
  end

  # validators -------------------------------------------------------------------------
  def valid_pm_tool?(name='chicken'); Settings.apps["#{name}"].present?; end
  def valid_search_params?
    unless params[:screen_name].present?
      die("missing_param", "Expected a :screen_name parameter")
      return false
    end
    unless valid_pm_tool? params[:pm_tool]
      die("invalid_param", "Invalid or missing :pm_tool parameter.")  
      return false
    end
    true
  end

  #-------------------------------------------------------------------------------------

  def track_screen_name
    client = twitter_auth.client
    # To Do: 
    # 1. handle duplicate tweets
    # 2. The streaming feed just keeps on coming, even when creating the task, 
    # so entries are missed each time the tweet_to_task method is busy.
    # 3. The stream cannot be cancelled without a server restart
    # 4. Only one track query can be performed!
    begin
      client.filter(:track => "#{screen_name}") do |tweet|
        next unless tweet.text?
        break if need_refresh?
        if tweet.text.match(/(\s|^)(@#{screen_name})([^a-zA-Z0-9_]|$)/i)
          Rails.logger.debug("MATCH #{screen_name} -> #{tweet.text}")
          return false unless tweet_to_task(tweet)
        else 
          Rails.logger.debug("MISS #{screen_name} -> #{tweet.text}")
        end
      end
    rescue => e # "Twitter::Error::TooManyRequests"
      Rails.logger.error("Twitter api error: #{e.inspect}")
      die("twitter_api_error", "#{e.inspect}")
      return false
    end
    if need_refresh?
      Rails.logger.info("Time to refresh the auth tokent for #{pm_tool}")
      refresh_auth_token
      return false
    end
    return true
  end

  def tweet_to_task(tweet)
      Rails.logger.debug("Attempt to create task")
      begin
        response = pm_tool_api.create_task(tweet)
        result   = JSON.parse(response)
      rescue => e
        Rails.logger.error("error creating task: #{e.inspect}")
        die("#{pm_tool}_error", "Unable to create task -> response: #{response}")
        return false
      end
      Rails.logger.info("Task #{result['id']} created successfully!")
      Rails.logger.debug("Task name: #{result['name']}")
      Rails.logger.debug("Task description: #{result['description']}")
      result
  end

end
