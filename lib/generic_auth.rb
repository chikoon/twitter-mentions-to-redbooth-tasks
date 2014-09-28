class GenericAuth
    attr_accessor :access_code, :access_token, :refresh_token, :session, :token_expires, :oauth_client, :config

    def initialize(args={})
      raise "Invalid arguments" unless valid_args?(args)
      @oauth_client   = args[:oauth_client]
      @session        = args[:session]
      props           = session["#{oauth_client}"] = {}
      @access_code    = props["access_code"]
      @access_token   = props["access_token"]
      @refresh_token  = props["refresh_token"]
      @token_expires  = props["token_expires"]
    end

    def authenticate
      # override me
      raise "Auth modules must implement the authenticate method"
    end

    def refresh
      #overrideme
      raise "Auth modules must implement the refresh method"
    end

    def authenticated?; (access_token.present? && !expired?); end
    def expired?;       !token_expires.present? || (token_expires.to_i < (DateTime.now + 1.minute).to_i); end
    def valid_args?(args={})
      fail("missing_argument", "expected a :session argument")   and return false unless args[:session].is_a? Hash
      fail("missing_argument", "expected a :oauth_client argument")  and return false unless args[:oauth_client].present?
      true
    end

end