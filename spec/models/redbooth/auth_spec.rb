require 'rails_helper'

describe Redbooth::Auth do

  before(:all){
    @session = {}
  }

  let(:auth){  Redbooth::Auth.new({ :session => @session }) }
  let(:bad_url) { "http://asldjfsaldjflwewnfwlehwfsfsjlf.com" }
  let(:config) { auth.config }

  describe "properties" do
    it "#oauth_client should return \"redbooth\"" do
      expect(auth.oauth_client).to eq 'redbooth'
    end
    it "#config should be a shortcut to configuration" do
      expect(config).to eq Settings.apps["#{auth.oauth_client}"]
    end
    it "access_token data should be nil by default" do
      %w(access_token refresh_token token_expires).each { |prop|
        expect(auth.send(prop)).to be nil
      }
    end
    it "necessary login configuration must be present" do
      %w(client_id client_secret).each { |prop|
        expect(config.auth.send(prop)).to_not be nil
      }
      %w(authorize auth_callback refresh_token refresh_callback).each { |prop|
        expect(config.auth.path.send(prop)).to_not be nil
      }
    end
  end

  describe "#authenticated?" do
    before(:each){
      allow(auth).to receive(:access_token).and_return('chicken')
    }
    it "should be true if access token is present and not expired" do
      allow(auth).to receive(:token_expires).and_return(DateTime.now + 1.hour)
      expect(auth.authenticated?).to be true
    end
    it "should be false if access token is missing" do
      allow(auth).to receive(:access_token).and_return(nil)
      expect(auth.authenticated?).to be false
    end
    it "should be false if access token has expired" do
      allow(auth).to receive(:token_expires).and_return(DateTime.now - 1.hour)
      expect(auth.authenticated?).to be false
    end
    it "should be false if access token is close to expiration" do
      allow(auth).to receive(:token_expires).and_return(DateTime.now + 59.seconds)
      expect(auth.authenticated?).to be false
    end
    describe "#expired?" do
      it "should be true if #token_expires is at least one minute in the future" do
        allow(auth).to receive(:token_expires).and_return(DateTime.now + 1.minute)
        expect(auth.expired?).to be false
      end
    end
  end


  describe "#authenticate!" do
    context "fails when" do
      #it "login and password parameters are missing" do
      #  allow(auth.config).to receive(:user_name).and_return(nil)
      #  allow(auth.config).to receive(:password).and_return(nil)
      #  expect{ auth.authenticate! }.to raise_error
      #end
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
