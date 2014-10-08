require 'rails_helper'

RSpec.describe "UserPages", :type => :request do
  subject { page }

  describe "Sign Up page" do
    before { visit signup_path }

    let(:submit) { "Create my account" }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_title full_title('Sign up') }

    describe "sending empty form" do
      it "should not change User count" do
        expect { click_button submit }.
          not_to change(User, :count)
      end
    end

    describe "sending filled form" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "example@railstutorial.org"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
      end

      it "should change User count by 1" do
        expect { click_button submit }.
          to change(User, :count).by(1)
      end
    end
  end
  describe "profile page" do
    # make a user
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    # it { should have_content(user.email) }
    it { should have_title(user.name) }
  end
end
