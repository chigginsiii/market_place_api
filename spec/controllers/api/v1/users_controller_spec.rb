require 'rails_helper'

describe Api::V1::UsersController do
  before (:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show" do
    before (:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a user on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect( user_response[:email] ).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    before (:each) do
      @user_attrs = FactoryGirl.attributes_for(:user)
      post :create, { user: @user_attrs }, format: :json
    end
    
    context "when creation is successful" do
      it "renders the json representation for the user record" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attrs[:email]
      end

      it { should respond_with 201 }
    end

    context "when creation is not successful" do
      before (:each) do
        @invalid_attrs = { password: '12345678', password_confirmation: '12345678' }
        post :create, { user: @invalid_attrs }, format: :json
      end

      it "renders the errors" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
      
      it "explains why the user could not be crated" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
      
    end
    
  end
end
