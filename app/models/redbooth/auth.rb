module Redbooth
  class Auth

    attr_accessor :access_token, :refresh_token, :token_expiration, :auth_cookie_name, :auth_cookie_value
    attr_reader :provider, :config

    def initialize
      @provider = 'redbooth'
      @config   = Settings.project_management_app["#{provider}"]
    end

    def ok?
      (access_token.present? && !expired?)
    end

    def expired?
      !token_expiration.present? || (token_expiration.to_i < (DateTime.now + 1.minute).to_i)
    end

    def authenticate!
      raise "Missing credentials" unless get_oauth_cookie
      code = get_oauth_code(auth_cookie_name, auth_cookie_value)
      return true
    end

    def get_oauth_cookie
      return false unless (config.user_name.present? && config.password.present?)
      begin
        response = RestClient.post "#{config.login_url}", { :login => config.user_name, :password => config.password }
      rescue => e
        raise "Login error: #{e.message}"
      end
      response.headers[:set_cookie].to_s.match(/^.+\"([^=]+)=([^;]+);.+$/){ |m|
        @auth_cookie_name  = m[1]
        @auth_cookie_value = m[2]
        return true
      }
      raise "Unable to extract sesssion cookie"
    end

    def get_oauth_code(cookie_name, cookie_value)
      Rails.logger.debug("cookie_name: #{cookie_name}")
      Rails.logger.debug("cookie_value: #{cookie_value}")
      #curl -i --cookie "#{cookie}" "#{config.authorize_url}?client_id=#{config.client_id}&redirect_uri=#{config.redirect_uri}&response_type=code"
      "chicken"
    end

  end
end
