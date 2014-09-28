require 'rails_helper'

RSpec.describe MentionsController, :type => :controller do

  describe "search" do
    it "GET returns http success" do
      #get '/redbooth/tasks/for/chicken/mentions'
      get :search, { :screen_name => 'chicken', :pm_tool => 'redbooth' }
      expect(response).to have_http_status(:success)
    end
    it "POST returns http success" do
      #post '/:pm_tool/search/mentions', { :screen_name => 'chicken' }
      post :search, { :screen_name => 'chicken', :pm_tool => 'redbooth' }
      expect(response).to have_http_status(:success)
    end
    it "fails when pm_tool parameter is invalid" do
      get :search, { :screen_name => 'chicken', :pm_tool => 'chicken' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['error']).to eq 'invalid_param'
    end
    it "fails when screen_name parameter is missing" do
      post :search, { :screen_name => nil, :pm_tool => 'chicken' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['error']).to eq 'missing_param'
    end
  end

end
