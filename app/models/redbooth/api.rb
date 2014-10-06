module Redbooth

  class Api < GenericApi

    include M2tUtil
    
    attr_accessor :access_token

    def initialize(token)
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
      response = safer_request("GET", "tasks?access_token=#{access_token}&user_id=#{user_id}&project_id=#{project_id}")
    end

    def create_task(tweet, args={})
      #args[:user_id]      = "#{user_id}"       unless args[:user_id].present?
      #args[:project_id]   = "#{project_id}"    unless args[:project_id].present?
      #args[:task_list_id] = "#{task_list_id}"  unless args[:task_list_id].present?
      #args[:access_token] = "#{access_token}"  unless args[:access_token].present?
      binding.pry
      conf = Settings.apps["#{pm_tool}"].user

      args[:user_id]      = conf[:id]
      args[:project_id]   = conf[:project_id]
      args[:task_list]    = conf[:task_list_id]
      args[:tweeter]      = args[:created_by]
      args[:created]      = args[:created_at]
      args
      
      args.keys{ |k| return nil if !args[k].present? }

      args[:name]         = "Tweet for #{args[:screen_name]} created by #{args[:tweeter]} at #{args[:created]}."
      args[:description]  = tweet
      binding.pry
      response = safer_request("POST", "/tasks", "#{args.to_json}")
    end

  end
end

