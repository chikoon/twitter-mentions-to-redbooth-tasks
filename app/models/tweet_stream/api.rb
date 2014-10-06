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

    def track_screen_name
      #binding.pry
      begin
        client.filter(:track => "#{screen_name}") do |tweet|
          next unless tweet.text?
          Rails.logger.debug("MISS #{screen_name} -> #{tweet.text}")
          if tweet.text.match("(@#{screen_name})([^a-zA-Z0-9_]|$)")
            Rails.logger.info("MATCH Track #{screen_name} -> #{tweet.text}")
            binding.pry
            created_at = DateTime.now
            created_at = tweet.created_at if tweet.created?
            created_by = 'Unknown'
            created_by = tweet.user.name  if tweet.user? && tweet.user.name?
            pm_tool_api.create_task(tweet.text, { 
              :created_at => created_at, 
              :created_by => created_by,
              :screen_name => screen_name
            })
            binding.pry
          end
        end
      rescue => e
        Rails.logger.error("Twitter api error: #{e.inspect}")
      end
    end

  end
end
