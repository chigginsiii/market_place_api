require 'rails_helper'

describe Api::V1::UsersController do
  before (:each) do
    request.headers['Accept'] = "application/vnd.marketplace.v1, #{Mime::JSON}"
    request.headers['Content-Type'] = Mime::JSON.to_s
  end

  describe "GET #show" do
    before (:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id
    end

    it "returns the information about a user on a hash" do
      user_response = json_response
      expect( user_response[:email] ).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    before (:each) do
      @user_attrs = FactoryGirl.attributes_for(:user)
      post :create, { user: @user_attrs }
    end
    
    context "when creation is successful" do
      it "renders the json representation for the user record" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attrs[:email]
      end

      it { should respond_with 201 }
    end

    context "when creation is not successful" do
      before (:each) do
        @invalid_attrs = { password: '12345678', password_confirmation: '12345678' }
        post :create, { user: @invalid_attrs }
      end

      it "renders the errors" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end
      
      it "explains why the user could not be crated" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
      
    end
    
  end

  describe "PUT/PATCH #update" do
    context "when is successfully updated" do
      before (:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: 'changed@example.org' }}
      end
      it "responds with updated user json" do
        user_response = json_response
        expect(user_response[:email]).to eql 'changed@example.org'
      end
    end
    
    context "when is not updated" do
      before (:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: 'badexample.org' } }
      end

      it "returns errors" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "returns a field-specific error message" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
      
    end
  end

  describe "DELETE #destroy" do
    before (:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.id }
    end

    it { should respond_with 204 }
    
  end
  
end
