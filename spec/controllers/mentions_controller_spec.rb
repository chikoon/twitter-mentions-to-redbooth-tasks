require 'rails_helper'

RSpec.describe MentionsController, :type => :controller do

  describe "GET start" do
    it "returns http success" do
      get :start, { :screen_name => 'chicken', :pm_tool => 'redbooth' }
      expect(response).to have_http_status(:success)
    end
  end

end
