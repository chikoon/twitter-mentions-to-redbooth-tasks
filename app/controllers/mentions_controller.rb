class MentionsController < ApplicationController
  attr_reader   :twitter_auth, :pm_tool_auth, :pm_api, :twitter_api
  before_filter :pm_tool, :pm_tool_auth, :twitter_auth, :authenticate!, :only => :search

  def initialize; super; end

  def search
    return unless valid_search_params?
    data = session.clone
    data.delete(:session_id)
    output = {
      "pm_tool:"    => params[:pm_tool],
      "screen_name" => params[:screen_name],
      "#{pm_tool}"  => {
          'auth' => data["#{params[:pm_tool]}"],
          'user' => pm_tool_api.me
      }
    }
    render :json => output
  end

  def posted_search
    return unless valid_search_params?
    redirect_to start_streaming_url :pm_tool => params[:pm_tool], :screen_name => params[:screen_name] 
  end

  def stop

  end
  #-------------------------------------------------------------------------------------

  def authenticate
    #binding.pry
    set_target_url(request.original_fullpath)
    unless pm_tool_auth.authenticated?
      redirect_to "/oauth/#{pm_tool}"
      return
    end
    #unless twitter_auth.authenticated?
    #  redirect_to "/oauth/twitter"
    #end
  end
  
  def authenticated?
    pm_tool_auth.authenticated? # && twitter_auth.authenticated?
  end

  def authenticate!
    return if authenticated?
    authenticate
  end

  #-------------------------------------------------------------------------------------

  def twitter_auth
    @twitter_auth ||= TweetStream::Auth.new( session.to_h )
  end

  def pm_tool_auth
    @pm_tool_auth ||= "#{pm_tool.capitalize}::Auth".constantize.new( session.to_h )
  end
  def pm_tool_api
    @pm_tool_api ||= "#{pm_tool.capitalize}::Api".constantize.new( pm_tool_auth.access_token )
  end

  #-------------------------------------------------------------------------------------


  def valid_pm_tool?(name='chicken')
    Settings.project_management_app["#{name}"].present?
  end

  def valid_search_params?
    fail("missing_param", "Expected a :screen_name parameter") and return false unless params[:screen_name].present?
    fail("invalid_param", "Invalid or missing :pm_tool parameter.") and return false unless valid_pm_tool? params[:pm_tool]
    true
  end

end
