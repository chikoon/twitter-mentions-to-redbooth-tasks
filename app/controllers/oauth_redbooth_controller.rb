class OauthRedboothController < ApplicationController

  def authenticate
    url = "#{config.authorize_url}?client_id=#{config.client_id}&redirect_uri=#{config.redirect_uri}&response_type=code"
    Rails.logger.debug(url)
    redirect_to url
  end

  def callback
    Rails.logger.debug(params)
    fail("oauth2_code", "Unable to retreive oauth code") unless params['code'].present?
    begin
      response = get_tokens(params['code'])
    rescue => e
      fail("oauth2_tokens", e.message)
      return
    end
    result = JSON.parse(response.body)
    session['redbooth'] = {
      :access_token  => result['access_token'],
      :refresh_token => result['refresh_token'],
      :token_expires => DateTime.now + result['expires_in'].seconds
    }
    target_url = get_target_url
    #binding.pry
    redirect_to target_url
  end


  def get_tokens(code)
    args = {
      :code => code,
      :client_id => config.client_id,
      :client_secret => config.client_secret,
      :grant_type => 'authorization_code',
      :redirect_uri => config.redirect_uri
    }
    RestClient.post( "#{config.token_url}", args )
  end

  def config
    @config || Settings.project_management_app.redbooth
  end


end
