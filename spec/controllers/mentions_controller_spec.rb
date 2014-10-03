require 'rails_helper'

RSpec.describe MentionsController, :type => :controller do

  describe "authenticated redbooth search" do

    let(:pm_tool){ "redbooth" }
    let(:user_json){ Rails.root.join('fixtures', pm_tool, 'user.json') }
    let(:access_token){ 'fuzzywuzzywasabear' }
    let(:pm_tool_api){ instance_double("Redbooth::Api") }

    before(:each) do
      allow(@controller).to receive(:authenticated?).and_return(true)
    end
    
    it "POSTed search redirects to a GET request" do
      #post '/:pm_tool/search/mentions', { :screen_name => 'chicken' }
      post :posted_search, { :screen_name => 'chicken', :pm_tool => pm_tool }
      expect(response).to have_http_status(302)
    end
    it "GET returns http success with valid parameters" do
      #get '/redbooth/tasks/for/chicken/mentions'
      allow(Redbooth::Api).to receive(:new).and_return(pm_tool_api)
      allow(pm_tool_api).to receive(:me).and_return(user_json)
      get :search, { :screen_name => 'chicken', :pm_tool => pm_tool, :access_token => access_token }
      expect(response).to have_http_status(:success)
    end
    it "fails when pm_tool parameter is invalid" do
      get :search, { :screen_name => 'chicken', :pm_tool => 'egg' }
      expect(response.code).to eq 200.to_s
      #have_http_status(:success)
      expect(JSON.parse(response.body)['error']).to eq 'invalid_param'
    end
    it "fails when screen_name parameter is missing" do
      post :search, { :screen_name => '', :pm_tool => 'chicken' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['error']).to eq 'missing_param'
    end

  end

end
