class OauthTwitterController < ApplicationController

  def index
    render :json => {}
  end

  def callback
    output = {
      pm_tool:      params[:pm_tool],
      screen_name:  params[:screen_name]
    }
    # logger.debug("good food")
    redirect_to :search_streaming  => output
  end

  def authenticate
  end

end
