class OauthTwitterController < ApplicationController

  def authenticate
    render :json => {}
  end

  def callback
    output = {
      pm_tool:      params[:pm_tool],
      screen_name:  params[:screen_name]
    }
    # logger.debug("good food")
    #render :json => output
    redirect_to "/"
  end

end
