
module TweetStream

  class Auth <  GenericAuth

    include M2tUtil
    attr_accessor :client

    def initialize(args={})
      args[:oauth_client] = 'twitter'
      super(args)
      @config = Settings.apps.twitter
      @client = authenticate!
    end

    def authenticate!
      clnt = Twitter::Streaming::Client.new do |conf|
        conf.consumer_key        = "#{config.user.api_key}"
        conf.consumer_secret     = "#{config.user.api_secret}"
        conf.access_token        = "#{config.auth.access_token}"
        conf.access_token_secret = "#{config.auth.access_token_secret}"
      end
      Rails.logger.debug("client: #{clnt.inspect}")
      clnt
    end
    def authenticated?
      (client && client.access_token) ? true : false
    end
  end

end
