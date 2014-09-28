
module TweetStream

  class Auth <  GenericAuth

    def initialize(args={})
      args[:provider] = 'twitter'
      super(args)
    end

    def authenticate
    end

  end

end
