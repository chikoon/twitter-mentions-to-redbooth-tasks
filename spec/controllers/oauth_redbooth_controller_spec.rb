require 'rails_helper'

RSpec.describe OauthRedboothController, :type => :controller do

  describe "succeeds when" do
    let(:config){ Settings.apps.redbooth }
    let(:http_root){ config.http_root  }
    let(:auth_url){ "#{http_root}#{config.auth.path.authorize}" }
    it "GET #authenticate returns http success" do
      allow(@controller).to receive(:authorize_url).and_return(auth_url)
      get :authenticate
      expect(response).to have_http_status(302)
      expect(subject).to redirect_to auth_url
    end
    it "GET #callback redirects" do
      allow(@controller).to receive(:get_tokens).and_return({"access_token"=>"good","refresh_token"=>"food","expires_in"=>7200})
      allow(@controller).to receive(:get_target_url).and_return(root_path)
      get :callback
      expect(response).to have_http_status(302)
      expect(subject).to redirect_to root_path
    end

  end

end
