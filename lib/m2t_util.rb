module M2tUtil

  def safer_request(method, url, params={}, headers=nil)
    Rails.logger.debug("Enter safer_request: method: #{method}, url: #{url}, params: #{params.inspect}, headers: #{headers}")
    begin
      case method
        when 'GET';  response = RestClient.get( url, headers )
        when 'POST'; response = RestClient.post( url, params, headers )
        else;        response = nil
      end
    rescue => e
      Rails.logger.error("Error: #{e.inspect}")
      return die("http_error", "Error: #{e.inspect}")
    end
    response
  end

  def die(code='unknown', msg='Unexpected Error')
    Rails.logger.error("FAILED: #{code} => #{msg}")
    flash[:alert] = "#{code.upcase}: #{msg}"
    redirect_to root_path
    #render :json => { 'error' => code, 'message'=>msg }
    #return false;
  end

  def smart_redirect
    target_url = get_target_url
    redirect_to target_url
  end
  def get_target_url(default_url=:about_url)
    return default_url unless session[:target_url].present?
    session[:target_url]
  end
  def set_target_url(url); session[:target_url] = url; end

end
