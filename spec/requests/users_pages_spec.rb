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
        let(:user) { User.find_by(email: "example@railstutorial.org") }
        
        it { should have_link('Sign out') }
        it { should have_selector('h1', text: user.name) }
        it { should have_selector('.alert.alert-success', text: "Welcome to the Sample App, Example User!") }
      end 
    end
  end
  describe "profile page" do
    # make a user
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    # and microposts
    let!(:m1) { FactoryGirl.create(:micropost, 
      user: user, content: "Hello") }
    let!(:m2) { FactoryGirl.create(:micropost, 
      user: user, content: "There") }

    before { visit user_path(user) }
    
    it { should have_title(user.name) }
    it { should have_content(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }

      describe "pagination" do
        before(:all) do
          @user = FactoryGirl.create(:user)
          50.times { |n| FactoryGirl.create(:micropost, 
            user: @user, content: "MSG #{n}") }
        end
        before { visit user_path(@user) }
        after(:all) { @user.destroy }
        # specify { expect(@user.microposts.count).to eq(50) }
        # it { should have_content @user.name }
        # it { should have_selector('.microposts') }
        it { should have_selector('.microposts li', count: 20) }
        it { should have_selector('.pagination') }
        it "should list first 20 messages" do
          @user.microposts.paginate(page: 1, per_page: 20).each do |mp|
            expect(page).to have_selector('.microposts li',text: mp.content)
          end
        end
      end

      describe "delete links" do
        before do
          visit signin_path
          valid_signin user
        end
        it { should have_selector('.microposts li a', 
          count: user.microposts.count, 
          text: 'delete') }
        
        describe "for other user" do
          before do 
            FactoryGirl.create(:micropost, user: other_user)
            visit user_path(other_user) 
          end
          it { should have_selector('.microposts') }
          it { should_not have_selector('.microposts li a', 
            text: 'delete') }
        end
      end
    end
  end
  describe "edit user" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit signin_path
      valid_signin(user)
      visit edit_user_path(user)
    end 

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', 
        href: 'http://gravatar.com/emails') }
      it { should have_selector('a[href="http://gravatar.com/emails"][target="_blank"]') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_error_message('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com".upcase }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email.downcase }
    end
  end
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit signin_path
      valid_signin user
      # FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      # FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    # it "should list each user" do
    #   User.all.each do |user|
    #     expect(page).to have_selector('li', text: user.name)
    #   end
    # end

    describe "pagination" do
      before(:all) { 99.times { |n| FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('.users li', count: 10) }
      it { should have_selector('.pagination') }

      it "should list first 10 users" do
        User.paginate(page: 1, per_page: 10).each do |user|
          expect(page).to have_selector('.users li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          visit signin_path
          valid_signin admin
          visit users_path
        end

        it { should have_link('delete', 
          href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }

      end
    end
  end
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        visit signin_path
        valid_signin user
        visit following_user_path(user)
      end

      it { should have_title full_title 'Following' }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        visit signin_path
        valid_signin other_user
        visit followers_user_path(other_user)
      end

      it { should have_title full_title 'Followers' }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
