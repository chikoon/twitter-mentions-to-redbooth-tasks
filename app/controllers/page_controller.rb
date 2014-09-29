class PageController < ApplicationController

  def about
    @pm_tool = pm_tool
    @session = session.to_h
    render :layout => 'application'
  end

end
