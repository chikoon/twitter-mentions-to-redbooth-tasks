class MentionsController < ApplicationController
#
  include M2tUtil

  before_filter :authenticate!, :only => [:search]

  def initialize;
    super
  end

  def search
    return unless valid_search_params?
    data = session.clone
    data.delete(:session_id)
    twitter_api.track_screen_name

    output = {
      "success"     => "Tracking #{params[:screen_name]}!",
      "pm_tool:"    => params[:pm_tool],
      "screen_name" => params[:screen_name],
      "#{pm_tool}"  => {
          'auth' => data["#{params[:pm_tool]}"],
          'user' => pm_tool_api.me
      },
      "twitter" => {
        'auth' => twitter_auth
      }
    }

    render :json => output
    return false
  end

  def posted_search
    return unless valid_search_params?
    redirect_to start_streaming_url({
      :pm_tool      => params[:pm_tool], 
      :screen_name  => params[:screen_name] 
    })
  end

  #-------------------------------------------------------------------------------------


  #-------------------------------------------------------------------------------------

end
