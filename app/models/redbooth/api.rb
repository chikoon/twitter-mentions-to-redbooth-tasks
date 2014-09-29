module Redbooth
  class Api
    attr_accessor :access_token

    def initialize(token)
      fail("missing param", "Expected :access_token") and return unless token.present?
      @access_token = token
    end

    def me
      begin
        response = RestClient.get( "https://redbooth.com/api/3/me?access_token=#{access_token}&format=xml")
      rescue => e
        Rails.logger.warn("http_error: {e.message}")
        return
      end
      return nil unless (response && response.code == 200)
      return Hash.from_xml(response)['user']
    end


    def fail(code="unexpected", msg="An unexpectd error has occurred")
      raise "#{code}: #{msg}"
    end
  end
end

