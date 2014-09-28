class ApplicationController < ActionController::Base
  protect_from_forgery

  attr_reader   :twitter_auth, :pm_tool_auth

  before_filter :pm_tool,
                :pm_tool_auth,
                :twitter_auth,
                :authenticate!

  def initialize(args={})
  end

  def fail(code='unknown', msg='Unexpected Error')
    logger.debug("FAILED: #{code} => #{msg}")
    render :json => { 'error' => code, 'messsage'=>msg }
  end

  def valid_pm_tool?(name='chicken')
    Settings.project_management_app["#{name}"].present?
  end

  def pm_tool
    @pm_tool ||= Settings.pm_tool
  end

  def twitter_auth
    @twitter_auth ||= TweetStream::Auth.new( { :session => session } )
  end

  def pm_tool_auth
    @pm_tool_auth ||= "#{pm_tool.capitalize}::Auth".constantize.new( { :session => session } )
  end

  def authenticated?
    return if twitter_auth.authenticated? && pm_tool_auth.authenticated?
  end

  def authenticate
    # override me
    return false
  end

  def authenticate!
    return if authenticated?
    authenticate
  end

end
