module TweetStream

  class Api < GenericApi
    
    include M2tUtil
    
    attr_accessor :screen_name, :client, :args
    attr_reader   :config

    def initialize(a={})
      super(@args = a)
      @client       = args[:client]
      @screen_name  = args[:screen_name]
      @query        = screen_name
    end

    #def safe_flow_filter(f=nil)
    #  return false unless f
    #  case f.is_a?
    #    when String
    #    when Array
    #    else
    #  end
    #  false
    #end
    def flow(filter=nil)
      topics = ["coffee", "tea"]
      client.filter(:track => topics.join(",")) do |object|
        binding.pry
        Rails.logger.debug(object.text) if object.is_a?(Twitter::Tweet)
      end
      #binding.pry
      Rails.logger.debug("#{self.class.name} streamer started!")
    end

    def dont_go_with_the_flow
      Rails.logger.debug("How to I stop this thing?")
    end
  end

end
