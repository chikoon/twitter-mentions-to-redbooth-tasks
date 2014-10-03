
module Redbooth

  class Auth < GenericAuth

    attr_accessor :code

    def initialize(args={})
      args[:oauth_client] = 'redbooth'
      super(args)
      @config = Settings.apps["#{oauth_client}"]
    end

    def refresh_token
      
    end

  end
end
