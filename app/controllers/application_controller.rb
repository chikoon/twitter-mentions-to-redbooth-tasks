class ApplicationController < ActionController::Base

  protect_from_forgery

  attr_reader   :screen_name, :pm_tool, 
                :pm_tool_auth, :pm_tool_api, 
                :twitter_auth, :twitter_api

  before_filter :setup, :pm_tool, 
                :pm_tool_auth, :pm_tool_api, 
                :twitter_auth, :twitter_api


  def initialize(args={}); end

  def setup
    @screen_name = params[:screen_name]
    session[:screen_name] = screen_name if screen_name.present?
    @pm_tool ||= Settings.app.project_management_tool
  end

  #instantiate auth and api classes
  def twitter_auth; @twitter_auth ||= TweetStream::Auth.new( session.to_h ); end
  def twitter_api;  @twitter_api  ||= TweetStream::Api.new( { :client => twitter_auth.client, :screen_name => screen_name } ); end

  def pm_tool_auth; @pm_tool_auth ||= "#{pm_tool.capitalize}::Auth".constantize.new( session.to_h ); end
  def pm_tool_api;  @pm_tool_api  ||= "#{pm_tool.capitalize}::Api".constantize.new( screen_name, pm_tool_auth ); end

  def tweet_to_task(screen_name, tweet); end # overwrite me! the PMTool Api class

  # authentication -------------------------------------------------------

  def authenticate
    set_target_url(request.original_fullpath)
    unless pm_tool_auth.authenticated?; redirect_to "/oauth/#{pm_tool}"; end
    return
  end
  def refresh; refresh_auth_token if pm_tool_auth.need_refresh?; end
  def refresh_auth_token
    set_target_url(request.original_fullpath)
    redirect_to oauth_redbook_refresh_url
  end
  def need_refresh?; pm_tool_auth.need_refresh?; end
  def authenticated?; pm_tool_auth.authenticated? && twitter_auth.authenticated?; end

  def authenticate!
    return if authenticated?
    if need_refresh?
      refresh
    else
      authenticate
    end
  end

end
