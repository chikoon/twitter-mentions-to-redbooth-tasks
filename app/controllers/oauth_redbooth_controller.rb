class OauthRedboothController < ApplicationController

  def authenticate; redirect_to authorize_url; end

  def authorize_url
    "#{http_base}#{config.auth.path.authorize}?" + 
      [ "client_id=#{config.auth.client_id}",
          "redirect_uri=#{callback_url}",
          "response_type=code"].join("&")
  end

  def callback_url; "#{app_base}#{config.auth.path.redirect}"; end

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
      flash[:alert] = message
      redirect_to root_url
      return true
    else
      Rails.logger.debug(params)
      return false
    end
  end

  def config; @config ||= Settings.apps.redbooth; end

  def http_base; config.http_base; end

  def get_tokens
    begin
      response = RestClient.post( get_tokens_url, get_tokens_params )
    rescue => e
      fail("oauth2_tokens", e.message) and return false
    end
    fail("http_error", "Request for tokens failes") and return false unless (response && response.code == 200)
    return JSON.parse(response.body)
  end

  def get_tokens_params
    p = {
        :code           => params[:code],
        :client_id      => config.auth.client_id,
        :client_secret  => config.auth.client_secret,
        :grant_type     => 'authorization_code',
        :redirect_uri   => "#{app_base}#{config.auth.path.redirect}"
    }
    #p.keys.each{ |k| return false unless p[k].present? }
    return p
  end

  def get_tokens_url; "#{http_base}#{config.auth.path.token}" end

end
