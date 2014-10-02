class ApplicationController < ActionController::Base
  protect_from_forgery

  def initialize(args={})
  end

  def fail(code='unknown', msg='Unexpected Error')
    Rails.logger.debug("FAILED: #{code} => #{msg}")
    render :json => { 'error' => code, 'messsage'=>msg }
  end

  def get_target_url(default_url=:about)
    return default_url unless session[:target_url].present?
    url = session[:target_url]
    session[:target_url] = nil
    url
  end
  def set_target_url(url)
    session[:target_url] = url
  end

  def pm_tool
    @pm_tool ||= Settings.app.project_management_tool
  end

  def app_base
    Settings.app.http_base
  end

end
