class ApplicationController < ActionController::Base
  protect_from_forgery

  def initialize(args={}); end

  def pm_tool; @pm_tool ||= Settings.app.project_management_tool; end
  def app_base; Settings.app.http_base; end

  def smart_redirect
    target_url = get_target_url
    redirect_to target_url
  end
  def get_target_url(default_url=:about_url)
    return default_url unless session[:target_url].present?
    session[:target_url]
  end
  def set_target_url(url); session[:target_url] = url; end

end
