class GenericAuth

  attr_accessor :config, :oauth_client, :session, :access_token, :refresh_token, :token_expires

  def initialize(args={})
    raise "Invalid arguments" unless valid_args?(args)
    @oauth_client = args[:oauth_client] 
  end
  def need_refresh?; (access_token && expired?); end
  def authenticated?; (access_token.present? && !expired?); end
  def expired?;       !token_expires.present? || (token_expires.to_i < (DateTime.now + 1.minute).to_i); end
  def valid_args?(args={})
    unless args.is_a? Hash
      die("missing_argument", "expected a :session hash")
      return false
    end
    unless args[:oauth_client].present?
      die("missing_argument", "expected an :oauth_client argument")
      return false  
    end
    true
  end

end