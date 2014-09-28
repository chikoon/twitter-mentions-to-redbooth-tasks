
module Redbooth

  class Auth < GenericAuth

    attr_accessor :code

    def initialize(args={})
      args[:oauth_client] = 'redbooth'
      super(args)
      @config = Settings.project_management_app["#{oauth_client}"]
    end

    def authenticate
    end

  end
end
