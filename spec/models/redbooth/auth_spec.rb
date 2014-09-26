require 'spec_helper'

describe Redbooth::Auth do

  before(:all){
    @session = {}
  }

  let(:auth){  Redbooth::Auth.new }
  let(:bad_url) { "http://asldjfsaldjflwewnfwlehwfsfsjlf.com" }


  describe "properties" do
    it "#provider should contain the provider name" do
      expect(auth.provider).to eq 'redbooth'
      expect(auth.config.user_name).to eq 'mike@chikoon.com'
    end
    it "#config should be a shortcut to configuration" do
      expect(auth.config).to eq Settings.project_management_app.redbooth
    end
    it "access_token data should be nil by default" do
      %w(access_token refresh_token token_expiration).each { |prop|
        expect(auth.send(prop)).to be nil
      }
    end
    it "necessary login configuration must be present" do
      %w(user_name password client_id client_secret authorize_url token_url cookie_name redirect_uri).each { |prop|
        expect(auth.config.send(prop)).to_not be nil
      }
    end
  end

  describe "#ok?" do
    before(:each){
      allow(auth).to receive(:access_token).and_return('chicken')
    }
    it "should be true if access token is present and not expired" do
      allow(auth).to receive(:token_expiration).and_return(DateTime.now + 1.hour)
      expect(auth.ok?).to be true
    end
    it "should be false if access token is missing" do
      allow(auth).to receive(:access_token).and_return(nil)
      expect(auth.ok?).to be false
    end
    it "should be false if access token has expired" do
      allow(auth).to receive(:token_expiration).and_return(DateTime.now - 1.hour)
      expect(auth.ok?).to be false
    end
    it "should be false if access token is close to expiration" do
      allow(auth).to receive(:token_expiration).and_return(DateTime.now + 59.seconds)
      expect(auth.ok?).to be false
    end
    describe "#expired?" do
      it "should be true if #token_expiration is at least one minute in the future" do
        allow(auth).to receive(:token_expiration).and_return(DateTime.now + 1.minute)
        expect(auth.expired?).to be false
      end
    end
  end


  describe "#authenticate!" do
    context "fails when" do
      it "user_name or login are missing" do
        allow(auth.config).to receive(:user_name).and_return(nil)
        expect(auth).to receive(:get_oauth_cookie)
        expect{ auth.authenticate! }.to raise_error
      end
      it "login and password parameters are missing" do
        allow(auth.config).to receive(:user_name).and_return(nil)
        allow(auth.config).to receive(:password).and_return(nil)
        expect{ auth.authenticate! }.to raise_error
      end
      it "#get_cookie receives an http error" do
        allow(auth.config).to receive(:user_name).and_return("chicken")
        allow(auth.config).to receive(:password).and_return("egg")
        allow(auth.config).to receive(:login_url).and_return(bad_url)
        expect{ auth.get_oauth_cookie }.to raise_error
      end
      it "when login resource fails, no cookie information can be extracted" do
        allow(auth.config).to receive(:login_url).and_return(bad_url)
        expect(auth.auth_cookie_name).to be_nil
      end
    end

    describe "succeeds" do
      context "when full authentication process acquires new tokens" do
        describe "#fetch_session_cookie" do

        end

        describe "#fetch_oauth_code" do

        end

        describe "#fetch_token" do

        end
      end

      context "when refreshable" do
        describe "#refresh_tokens" do

        end
      end
    end

  end

  describe "#valid_token?" do


  end






end
