require 'rails_helper'

RSpec.describe Api::V1::SessionsController, :type => :controller do

  let! (:user) { FactoryGirl.create(:user) }
  let (:valid_credentials) { { email: user.email, password: user.password } }
  let (:invalid_credentials) { { email: user.email, password: 'incorrect' } }

  describe "POST #create" do

    context "with valid credentials" do
      before (:each) { post :create, { session: valid_credentials } }
      
      it { should respond_with 200 }

      it "returns the correct user record" do
        expect(json_response[:email]).to eql user.email
      end

      it "sets the user auth token" do
        user.reload
        expect(json_response[:auth_token]).to eql user.auth_token
      end
    end

    context "with invalid credentials" do
      before (:each) { post :create, { session: invalid_credentials } }

      it { should respond_with 422 }

      it "should return error json" do
        expect(json_response[:errors]).to eql "Invalid email or password"
      end
    end

  end

  describe "DELETE #destroy" do

    before do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, id: user.auth_token
    end

    it { should respond_with 204 }

  end
end
