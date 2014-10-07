require 'rails_helper'

RSpec.describe User, :type => :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com")
  end
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  describe "when name is too long" do
    before { @user.name = "A"*51 }
    it { should_not be_valid }
  end

  describe "when email is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org ex.user@foo 
        foo@bar_baz.com foo@bar+baz.com foo..@bar.jp foo@bar..com
        fo..o@bar.baz foo.@bar.baz foo@.bar.baz foo@bar..baz]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM us_e-r@f.o.o.org ex.user@foo.com 
        fo+o@barbaz.jp foo@barbaz.net]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email.upcase!
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  describe "when email address is set in upcase" do
    before do
      @user_email_upcase = @user.email.upcase
      @user.email = @user_email_upcase
    end
    it "should be saved as downcase" do
      @user.save
      @user.reload
      expect(@user.email).to eq(@user_email_upcase.downcase)
    end
  end
end
