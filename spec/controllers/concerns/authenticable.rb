require 'rails_helper'

class Authentication
  include Authenticable
  def request; end
  def response; end
end

RSpec.describe "Authenticable" do

  let (:authentication) { Authentication.new }

  describe "#current_user" do

    context "when Authentication header is set" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:request).and_return(request)
      end

      it "sets current user" do
        request.headers['Authorization'] = @user.auth_token
        expect(authentication.current_user.auth_token).to eql @user.auth_token
      end

    end
  end

  describe "#authenticate_with_token!" do

    before do
      @user = FactoryGirl.create(:user)
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({errors: :"Not authenticated"}.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it "responds with an error" do
      expect(json_response[:errors]).to eql 'Not authenticated'
    end

  end

end