module Redbooth
  class Auth

    attr_accessor :access_token, :refresh_token, :token_expiration
    attr_reader :provider, :config

    def initialize
      @provider = 'redbooth'
      @config   = Settings.project_management_app["#{@provider}"]
    end

    def ok?
      (access_token.present? && !expired?)
    end

    def expired?
      (!token_expiration.present? || token_expiration.to_i < (DateTime.now + 1.minute).to_i)
    end

  end
end
