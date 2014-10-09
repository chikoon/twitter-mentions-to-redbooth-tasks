class PageController < ApplicationController

  def about
    @screen_name  = session[:screen_name]; 
    @pm_tool_auth = pm_tool_auth
    @twitter_auth = twitter_auth
    @session      = session.to_h
    session.delete(:screen_name)
    session.delete(:target_url)
    twitter_auth.client = nil
    render :layout => 'application'
  end

end
