require 'rails_helper'

RSpec.describe User, :type => :model do
  before (:each) do
    @user = FactoryGirl.build(:user)
    @unique_token = 'unique_token_123'
  end

  subject {@user }

  [:email, :password, :password_confirmation].each do |attr|
    it { should respond_to(attr) }
  end

  it { should be_valid }

  # say hello to shoulda-matchers!
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_confirmation_of(:password) }
  # oh this is cooooool
  it { should allow_value('example@domain.com').for(:email) }
  # auth
  it { should respond_to(:auth_token) }
  it { should validate_uniqueness_of(:auth_token) }

  describe "#generate_authentication_token" do
    
    it "generates a unique token" do
      expect(Devise).to receive(:friendly_token) { @unique_token }
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql @unique_token
    end

    context "when another user has the same token" do
      it "generates a different token" do
        existing_user = FactoryGirl.create(:user, auth_token: @unique_token)
        @user.generate_authentication_token!
        expect(@user.auth_token).to_not eql existing_user.auth_token
      end
    end
  end

end
