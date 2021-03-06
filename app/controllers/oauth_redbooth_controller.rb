class OauthRedboothController < ApplicationController

  include M2tUtil
  
  def app_base;  Settings.app.http_base; end
  def config;    @config ||= Settings.apps.redbooth; end
  def http_base; config.http_base; end
  
  # get auth credentials ----------------------------------------
  def authenticate; redirect_to "#{auth_url}"; end
  def auth_url
    "#{http_base}#{config.auth.path.authorize}?"+ 
      [ "client_id=#{config.auth.client_id}",
        "redirect_uri=#{auth_callback_url}",
        "response_type=code"
      ].join("&"); 
  end
  def get_auth_tokens
    result = safer_request( 'POST', "#{http_base}#{config.auth.path.auth_token}",
        {
          :code           => params[:code],
          :client_id      => config.auth.client_id,
          :client_secret  => config.auth.client_secret,
          :grant_type     => 'authorization_code',
          :redirect_uri   => auth_callback_url
        })
    if result
      return JSON.parse(result)
    else 
      die("http_error", "Request for auth tokens failed")
      return false
    end
  end
  def auth_callback_url; "#{app_base}#{config.auth.path.auth_callback}"; end
  def auth_callback; callback { get_auth_tokens }; end

  # refresh  auth credentials ----------------------------------------
  def refresh
    Rails.logger.info("refreshing: ")
    response          = safer_request( 'POST', refresh_url, {
      :code           => params[:code],
      :client_id      => config.auth.client_id,
      :refresh_token  => session[:redbooth][:refresh_token],
      :grant_type     => 'refresh_token',
      :redirect_uri   => refresh_callback_url
    })
    unless response
      die("http_error", "Request for auth tokens failed")
      return false
    end
    result = JSON.parse(response)
    callback {{
      'access_token'  => result['access_token'],
      'refresh_token' => result['refresh_token'],
      'expires_in'    => result['expires_in']
    }}
    return false
  end
  def refresh_url; "#{http_base}#{config.auth.path.refresh_token}"; end
  def refresh_callback_url; "#{app_base}#{config.auth.path.refresh_callback}"; end;


  # callback handlers ----------------------------------------
  def callback(&block)
    result = block.call if block_given?
    return unless result && result.present? && !callback_error? 
    session['redbooth'] = {
      :access_token  => result['access_token'],
      :refresh_token => result['refresh_token'],
      :token_expires => DateTime.now + result['expires_in'].seconds
    }
    smart_redirect
  end

  def callback_error?
    if params[:error].present?
      return false unless  params[:error_description].present?
      message = "Unable to retreive oauth error description"
      message = params[:error_description]
      Rails.logger.warn('message');
      flash[:alert] = message
      redirect_to root_url
      return true
    else
      Rails.logger.debug(params)
    end
    return false
  end

end
