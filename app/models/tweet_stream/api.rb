module TweetStream

  class Api < GenericApi

    include M2tUtil

    attr_accessor :screen_name, :client, :args, :user
    attr_reader   :config

    def initialize(a={})
      @args = a
      @client       = args[:client]
      @screen_name  = args[:screen_name]
      @query        = screen_name
    end

  end
end
