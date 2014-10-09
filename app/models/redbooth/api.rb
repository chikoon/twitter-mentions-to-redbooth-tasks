module Redbooth

  class Api < GenericApi

    include M2tUtil
    attr_accessor :access_token, :http_base, :auth, :pm_tool, :screen_name

    def initialize(screen_name, auth)
      @pm_tool      = 'redbooth'
      @auth         = auth
      @access_token = auth.access_token
      @http_base    = 'https://redbooth.com/api/3/'
      @screen_name  = screen_name
    end

def create_task(tweet)
    Rails.logger.debug("Enter create task: tweet => #{tweet.inspect}")
    conf      = Settings.apps["#{pm_tool}"].user
    creator   = (tweet.user? && tweet.user.name?) ? tweet.user.name : 'Unknown'
    created   = (tweet.created?) ? tweet.created_at : DateTime.now
    task_name = "#{creator} mentioned @#{screen_name} on #{created.strftime('%m/%d/%Y')} at #{created.strftime('%I:%M%p')}."
    args = {
      :project_id   => conf[:project_id],
      :task_list_id => conf[:task_list_id],
      :name         => task_name,
      :description  => tweet.text,
      :access_token => auth.access_token,
      :format       => 'json'
    }
    headers = { :content_type => :json, :Authorizaton => "Bearer #{auth.access_token}" }
    safer_request("POST", "https://redbooth.com/api/3/tasks", args.to_json, headers)
  end

    # redbooth api endpoints -----------------------------------------------------------------
    def me
      response = safer_request('GET', "#{http_base}me?access_token=#{access_token}&format=xml")
      return handle_response(response)
    end

    def projects user_id
      response = safer_request("GET", "#{http_base}projects?access_token=#{access_token}&user_id=#{user_id}")
      return handle_response(response)
    end

    def task_lists user_id, project_id
      response = safer_request("GET", "#{http_base}task_lists?access_token=#{access_token}&user_id=#{user_id}&project_id=#{project_id}")
      return handle_response(response)
    end

    def tasks
      response = safer_request("GET", "#{http_base}tasks?access_token=#{access_token}&user_id=#{user_id}&project_id=#{project_id}")
      return handle_response(response)
    end

    # response handler -----------------------------------------------------------------------
    def handle_response(response)
      return false unless (response && response.code == 200)
      return Hash.from_xml(response)
    end

  end
end

