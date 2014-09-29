require 'rails_helper'

RSpec.describe OauthTwitterController, :type => :controller do

  describe "succeeds when" do
    it "GET #authenticate returns http success" do
      get :authenticate
      expect(response).to have_http_status(:success)
    end
    it "GET #callback redirects" do
      get :callback
      expect(response).to have_http_status(302)
      expect(subject).to redirect_to '/'
    end

  end

end
