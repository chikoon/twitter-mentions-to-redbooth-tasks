class OauthTwitterController < ApplicationController

  include     M2tUtil

  attr_reader :api, :client

  def initialize(args={})
    super(args)
    @client = twitter_auth
    @api    = twitter_api
  end

  #def authenticate; render :json => { 'client' => "#{client.inspect}" }; end

end
