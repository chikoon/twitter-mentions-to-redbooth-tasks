class ApplicationController < ActionController::Base
  protect_from_forgery
  attr_reader   :twitter_auth, :pm_tool_auth
  before_filter :pm_tool, :pm_tool_auth, :twitter_auth

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
    return true if pm_tool_auth.authenticated? # &&twitter_auth.authenticated? 
    false
  end

  def authenticate
    # override me
    # save the original url in session to be called in the oauth_callback function
    binding.pry
    unless pm_tool_auth.authenticated?
      redirect_to "/oauth/#{pm_tool}"
    end
    #unless twitter_auth.authenticated?
    #  redirect_to "/oauth/twitter"
    #end
  end

  def authenticate!
    return if authenticated?
    authenticate
  end

end
