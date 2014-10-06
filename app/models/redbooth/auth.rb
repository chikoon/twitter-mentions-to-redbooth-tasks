
module Redbooth

  class Auth < GenericAuth

    include M2tUtil

    def initialize(args={})
      args[:oauth_client] = 'redbooth'
      super(args)
      @config = Settings.apps["#{oauth_client}"]
      @session      = args["#{oauth_client}"]
      return unless session.is_a? Hash
      @access_token   = session[:access_token]
      @refresh_token  = session[:refresh_token]
      @token_expires  = session[:token_expires]
    end

  end
end
