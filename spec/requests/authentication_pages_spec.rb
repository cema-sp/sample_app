require 'rails_helper'

RSpec.describe "AuthenticationPages", :type => :request do
  subject { page }

  describe "Sign In page" do
    before { visit signin_path }

    let(:submit) { "Sign in" }

    it { should have_content("Sign In") }
    it { should have_title("Sign In") }
    it { should have_selector('input#session_email') }
    it { should have_selector('input#session_password') }

    describe "with empty credentials" do
      before { click_button submit }

      it { should have_content("Sign In") }
      it { should have_selector('.alert.alert-danger', text: "blank") }
    end

    describe "with wrong credentials" do
      before do
        fill_in "Email", with: "e@mail.com"
        fill_in "Password", with: "password"
        click_button submit
      end

      it { should have_content("Sign In") }
      it { should have_selector('.alert.alert-danger', text: "Invalid") }
    
      describe "after visiting another page" do
        before { click_link "Home" }

        it { should_not have_selector('.alert.alert-danger', text: "Invalid") }
      end
    end

    describe "with right credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button submit
      end

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "after signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end
end
