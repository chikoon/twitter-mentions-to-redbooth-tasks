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
      post :posted_search, { :screen_name => 'chicken', :pm_tool => pm_tool }
      expect(response).to have_http_status(302)
    end
    #it "GET returns http success with valid parameters" do
    #  allow(Redbooth::Api).to receive(:new).and_return(pm_tool_api)
    #  allow(pm_tool_api).to receive(:me).and_return(user_json)
    #  get :search, { :screen_name => 'chicken', :pm_tool => pm_tool, :access_token => access_token }
    #  expect(response).to eq 302.to_s
    #end
    it "fails when pm_tool parameter is invalid" do
      get :search, { :screen_name => 'chicken', :pm_tool => 'egg' }
      expect(flash.entries.count).to eq 1
      expect(flash.entries[0][0]).to eq :alert
      expect(flash.entries[0][1]).to match(/invalid_param/i)
      expect(response.code).to eq 302.to_s
    end
    it "fails when screen_name parameter is missing" do
      post :search, { :screen_name => '', :pm_tool => 'chicken' }
      expect(flash.entries.count).to eq 1
      expect(flash.entries[0][0]).to eq :alert
      expect(flash.entries[0][1]).to match(/missing_param/i)
      expect(response.code).to eq 302.to_s
    end

  end

end
