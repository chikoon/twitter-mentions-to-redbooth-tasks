class ApplicationController < ActionController::Base
  protect_from_forgery

  attr_reader   :twitter_auth, :pm_tool_auth

  before_filter :provider,
                :twitter_auth,
                :pm_tool_auth,
                :authenticate!

  def initialize(args={})
  end

  def fail(code='unknown', msg='Unexpected Error')
    logger.debug("FAILED: #{code} => #{msg}")
    render :json => { 'error' => code, 'messsage'=>msg }
  end

  def valid_provider?(name='chicken')
    Settings.project_management_app["#{name}"].present?
  end

  def provider
    @provider ||= Settings.provider
  end

  def twitter_auth
    @twitter_auth ||= TweetStream::Auth.new( { :session => session } )
  end

  def pm_tool_auth
    @pm_tool_auth ||= "#{provider.capitalize}::Auth".constantize.new( { :session => session } )
  end

  def authenticated?
    return if twitter_auth.authenticated? && pm_tool_auth.authenticated?
  end

  def authenticate
    # override me
    return false
  end

  def authenticate!
    authenticate
    # override me
    #fail("auth_error", "#{provider.capitalize} authentication failed") and return unless authenticated?
    #fail('auth_error', 'Twitter authentication failed') and return unless twitter_auth.authenticate
    #fail('auth_error', "#{provider.capitalize} authentication failed") and return false unless pm_tool_auth.authenticate
  end

end
