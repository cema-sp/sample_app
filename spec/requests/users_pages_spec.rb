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

    describe "sending form with empty" do
      before { click_button submit }
      context "name" do
        it { should have_selector('#error_explanation ul li',
            text: "Name can't be blank") }
      end
      context "email" do
        it { should have_selector('#error_explanation ul li',
            text: "Email can't be blank") }
      end
      context "password" do
        it { should have_selector('#error_explanation ul li',
            text: "Password can't be blank") }
      end
    end
    describe "sending form with wrond" do
      context "email" do
        before do
          fill_in "Email", with: "a@b..com"
          click_button submit
        end
        it { should have_selector('#error_explanation ul li',
            text: "Email is invalid") }
      end
      context "name" do
        before do
          fill_in "Name", with: "a"*51
          click_button submit
        end
        it { should have_selector('#error_explanation ul li',
            text: "Name is too long") }
      end
      context "password" do
        before do
          fill_in "Password", with: "short"
          click_button submit
        end
        it { should have_selector('#error_explanation ul li',
            text: "Password is too short") }
      end
    end

    describe "sending correctly filled form" do
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
      describe "click submit" do
        before { click_button submit }
        it { should have_selector('h1', text: "Example User") }
        it { should have_selector('.alert.alert-success', text: "Welcome to the Sample App, Example User!") }
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
