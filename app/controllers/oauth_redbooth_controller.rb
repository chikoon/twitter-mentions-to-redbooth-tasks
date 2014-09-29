class OauthRedboothController < ApplicationController

  def authenticate
    redirect_to authorize_url
  end

  def callback
    Rails.logger.debug(params)
    return if callback_error
    return unless result = get_tokens
    session['redbooth'] = {
      :access_token  => result['access_token'],
      :refresh_token => result['refresh_token'],
      :token_expires => DateTime.now + result['expires_in'].seconds
    }
    target_url = get_target_url
    redirect_to target_url
  end

  def callback_error
    if params[:error].present? || !params[:code].present? 
      message = (params[:error_description].present?) ?  params[:error_description] : "Unable to retreive oauth code"
      Rails.logger.warn('message');
      flash[:error] = message
      redirect_to root_url
      return true
    else
      Rails.logger.debug(params)
      return false
    end
  end

  def authorize_url
    "#{config.authorize_url}?client_id=#{config.client_id}&redirect_uri=#{config.redirect_uri}&response_type=code"
  end

  def get_tokens
    begin
      response = RestClient.post( "#{config.token_url}", {
        :code           => params[:code],
        :client_id      => config.client_id,
        :client_secret  => config.client_secret,
        :grant_type     => 'authorization_code',
        :redirect_uri   => config.redirect_uri
      } )
    rescue => e
      fail("oauth2_tokens", e.message) and return false
    end
    fail("http_error", "Request for tokens failes") and return false unless (response && response.code == 200)
    return JSON.parse(response.body)
  end

  def config
    @config ||= Settings.project_management_app.redbooth
  end


end
