class ApplicationController < ActionController::Base
  protect_from_forgery

  attr_reader   :pm_tool, :pm_tool_auth, :pm_tool_api, :twitter_auth, :twitter_api
  before_filter :pm_tool, :pm_tool_auth, :pm_tool_api, :twitter_auth, :twitter_api


  def initialize(args={}); end

  def pm_tool; @pm_tool ||= Settings.app.project_management_tool; end
  def app_base; Settings.app.http_base; end

  #instantiate auth and api classes
  def twitter_auth; @twitter_auth ||= TweetStream::Auth.new( session.to_h ); end
  def twitter_api;  @twitter_api  ||= TweetStream::Api.new( { :client => twitter_auth.client, :screen_name => params[:screen_name]} ); end

  def pm_tool_auth; @pm_tool_auth ||= "#{pm_tool.capitalize}::Auth".constantize.new( session.to_h ); end
  def pm_tool_api;  @pm_tool_api  ||= "#{pm_tool.capitalize}::Api".constantize.new( pm_tool_auth.access_token ); end


  def valid_pm_tool?(name='chicken'); Settings.apps["#{name}"].present?; end
  def valid_search_params?
    unless params[:screen_name].present?
      return die("missing_param", "Expected a :screen_name parameter")
    end
    unless valid_pm_tool? params[:pm_tool]
      return die("invalid_param", "Invalid or missing :pm_tool parameter.")  
    end
    true
  end

  # authentication -------------------------------------------------------

  def authenticate
    set_target_url(request.original_fullpath)
    unless pm_tool_auth.authenticated?; redirect_to "/oauth/#{pm_tool}"; end
    #unless twitter_auth.authenticated?; die("auth_error", "Unable to authenticate with Twitter"); end
    return
  end
  def refresh
    pm_tool_auth.refresh_token if pm_tool_auth.refreshable?
    #twitter_auth.refresh_token if twitter_auth.refreshable?
  end
  def refreshable?
    pm_tool_auth.refreshable? #|| twitter_auth.refreshable?
  end
  def authenticated?
    pm_tool_auth.authenticated? #&& twitter_auth.authenticated?
  end

  def authenticate!
    return if authenticated?
    if refreshable?
      refresh
    else
      authenticate
    end
  end

end
