class GenericAuth
    attr_accessor :access_code, :access_token, :refresh_token, :session, :token_expires, :provider, :config

    def initialize(args={})
      raise "Invalid arguments" unless valid_args?(args)
      @provider       = args[:provider]
      @session        = args[:session]
      props           = session["#{provider}"] = {}
      @config         = Settings.project_management_app["#{provider}"]
      @access_code    = props["access_code"]
      @access_token   = props["access_token"]
      @refresh_token  = props["refresh_token"]
      @token_expires  = props["token_expires"]
    end

    def authenticate
      # override me
      raise "Auth modules must implement the authenticated method"
    end

    def authenticated?; (access_token.present? && !expired?); end
    def expired?;       !token_expires.present? || (token_expires.to_i < (DateTime.now + 1.minute).to_i); end
    def valid_args?(args={})
      fail("missing_argument", "expected a :session argument")   and return false unless args[:session].is_a? Hash
      fail("missing_argument", "expected a :provider argument")   and return false unless args[:provider].present?
      true
    end

end