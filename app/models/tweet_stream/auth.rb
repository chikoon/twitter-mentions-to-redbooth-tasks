
module TweetStream

  class Auth <  GenericAuth

    def initialize(args={})
      args[:oauth_client] = 'twitter'
      super(args)
      @config = Settings["#{oauth_client}"]
    end

    def refresh_token

    end
  end

end
