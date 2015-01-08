require 'rails_helper'

class Authentication
  include Authenticable
  def request; end
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
end