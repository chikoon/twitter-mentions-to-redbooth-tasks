class MentionsController < ApplicationController

  def initialize
    super
  end

  def search
    return unless valid_search_params?
    render :json => {
      pm_tool:      params[:pm_tool],
      screen_name:  params[:screen_name],
      cookie:       cookies.inspect
    }.to_json
  end

  def valid_search_params?
    fail("missing_param", "Expected a :screen_name parameter") and return false unless params[:screen_name].present?
    fail("invalid_param", "Invalid or missing :pm_tool parameter.") and return false unless valid_provider? params[:pm_tool]
    true
  end

  def stop

  end

  def about
  end


end
