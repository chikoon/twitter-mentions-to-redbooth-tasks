module TweetStream

  class Streamer
    def self.start
      #binding.pry
      Rails.logger.debug("#{self.class.name} streamer started!")
    end

    def self.stop
      Rails.logger.debug("#{self.class.name} stopped!")
    end
  end

end
