
module Redbooth

  class Auth < GenericAuth

    attr_accessor :code

    def initialize(args={})
      args[:provider] = 'redbooth'
      super(args)
    end

    def authenticate
    end

  end
end
