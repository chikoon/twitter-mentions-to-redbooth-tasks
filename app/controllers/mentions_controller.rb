class MentionsController < ApplicationController
  before_filter :authenticate!
  attr_accessor :auth


  def start
    output = {
      pm_tool:      params[:pm_tool],
      screen_name:  params[:screen_name],
      cookie:       cookies.inspect
    }
    # logger.debug("good food")
    render :json => output.to_json
  end

  def stop

  end

  #def auth; @auth; end

  def authenticate!
    auth = Redbooth::Auth.new
    begin
      auth.authenticate!
    rescue => e
      render json: { :error => "auth_error", :message => "#{e.message}" }
    end
  end

end
