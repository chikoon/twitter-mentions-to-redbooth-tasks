module M2tUtil
  def safer_request(method, url, params={})
    begin
      case method
        when 'GET';  response = RestClient.get( url )
        when 'POST'; response = RestClient.post( url, params )
        else;        response = nil
      end
    rescue => e
      return fail("bad response", "#{e.message} ---\n #{response.inspect}")
    end
    return fail("http_error", "Request for tokens failes") unless (response && response.code == 200)
    response
  end
  def fail(code='unknown', msg='Unexpected Error')
    Rails.logger.debug("FAILED: #{code} => #{msg}")
    render :json => { 'error' => code, 'messsage'=>msg }
    return false;
  end
end