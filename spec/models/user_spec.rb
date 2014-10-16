require 'rails_helper'

RSpec.describe User, :type => :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com", 
      password: "password", password_confirmation: "password")
  end
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }

  it { should be_valid }
  it { should_not be_admin }

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
      @user.email = @user_email_upcase = @user.email.upcase
    end
    it "should be saved as downcase" do
      @user.save
      @user.reload
      expect(@user.email).to eq(@user_email_upcase.downcase)
    end
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = '111' }
    it { should_not be_valid }
  end
  describe "when a password is too short" do
    before { @user.password = @user.password_confirmation = "a"*5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("111") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_falsey }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
end
