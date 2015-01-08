require 'rails_helper'

RSpec.describe User, :type => :model do
  before { @user = FactoryGirl.build(:user) }
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

end
