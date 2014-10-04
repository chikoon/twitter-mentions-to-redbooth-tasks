
module Redbooth

  class Auth < GenericAuth

    include M2tUtil

    def initialize(args={})
      args[:oauth_client] = 'redbooth'
      super(args)
      @config = Settings.apps["#{oauth_client}"]
    end

  end
end
