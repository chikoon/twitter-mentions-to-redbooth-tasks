class GenericAuth
    attr_accessor :config, :oauth_client, :session, :access_token, :refresh_token, :token_expires

    def initialize(args={})
      raise "Invalid arguments" unless valid_args?(args)
      @oauth_client = args[:oauth_client]
      @session      = args["#{oauth_client}"]
      return unless session.is_a? Hash
      @access_token   = session[:access_token]
      @refresh_token  = session[:refresh_token]
      @token_expires  = session[:token_expires]
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
      fail("missing_argument", "expected a :session argument")      and return false unless args.is_a? Hash
      fail("missing_argument", "expected a :oauth_client argument") and return false unless args[:oauth_client].present?
      true
    end

end