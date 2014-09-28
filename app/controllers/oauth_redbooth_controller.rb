class OauthRedboothController < ApplicationController

  def authenticate
    url = "#{config.authorize_url}?client_id=#{config.client_id}&redirect_uri=#{config.redirect_uri}&response_type=code"
    logger.debug(url)
    redirect_to url
  end

  def callback
    logger.debug(params)
    fail("oauth2_code", "Unable to retreive oauth code") unless params['code'].present?
    begin
      tokens = get_tokens(params['code'])
    rescue => e
      fail("oauth2_tokens", e.message)
    end
    #JSON.parse(response.body)
    binding.pry
    # logger.debug("good food")
    redirect_to authorize_url
  end


  def get_tokens(code)
    args = {
      :code => code,
      :client_id => config.client_id,
      :client_secret => config.client_secret,
      :grant_type => 'authorization',
      :redirect_uri => config.redirect_uri
    }
    response = RestClient.post( "#{config.token_url}", args )
  end

  def config
    @config || Settings.project_management_app.redbooth
  end


end
