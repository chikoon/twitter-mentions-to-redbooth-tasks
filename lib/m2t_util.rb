module M2tUtil

  def safer_request(method, url, params={})
    Rails.logger.info("#{method}: #{url} -> #{params.to_query}")
    begin
      case method
        when 'GET';  response = RestClient.get( url )
        when 'POST'; response = RestClient.post( url, params )
        else;        response = nil
      end
    rescue => e
      return die("bad response", "#{e.message} ---\n #{response.inspect}")
    end
    return die("http_error", "Request for tokens failes") unless (response && response.code == 200)
    response
  end

  def die(code='unknown', msg='Unexpected Error')
    Rails.logger.error("FAILED: #{code} => #{msg}")
    render :json => { 'error' => code, 'messsage'=>msg }
    return false;
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
