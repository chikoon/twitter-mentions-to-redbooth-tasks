module Redbooth

  class Api

    attr_accessor :access_token

    def initialize(token)
      fail("missing param", "Expected :access_token") and return unless token.present?
      @access_token = token
    end

    # api endpoints --------------------------------------------------------------------------

    def me
      response = safer_request('GET', "https://redbooth.com/api/3/me?access_token=#{access_token}&format=xml")
      return nil unless (response && response.code == 200)
      return Hash.from_xml(response)['user']
    end

    def projects user_id
      response = safer_request("GET", "projects?access_token=#{access_token}&user_id=#{user_id}")
    end

    def task_lists user_id, project_id
      response = safer_request("GET", "task_lists?access_token=#{access_token}&user_id=#{user_id}&project_id=#{project_id}")
    end

    def tasks
      response = safer_request("GET", "/tasks?access_token=#{access_token}&user_id=#{user_id}&project_id=#{project_id}")
    end

    def create_task(name="new task", args={})
      args[:user_id]      = "#{user_id}"       unless args[:user_id].present?
      args[:project_id]   = "#{project_id}"    unless args[:project_id].present?
      args[:task_list_id] = "#{task_list_id}"  unless args[:task_list_id].present?
      args[:access_token] = "#{access_token}"  unless args[:access_token].present?
      args.keys{ |k| return nil if !args[k].present? }
      response = safer_request("POST", "/tasks", "#{args.to_json}")
    end

    # helper methods -------------------------------------------------------------------------
    # To-do: stop duplicating these two methods in this fail and in the application controller
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
end

