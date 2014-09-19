class MentionsController < ApplicationController

  def start

    output = {
      pm_tool:      params[:pm_tool],
      screen_name:  params[:screen_name]
    }

    logger.debug("good food")
    render :json => output.to_json
  end

  def stop

  end

end
