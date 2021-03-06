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
      it { should have_error_message "blank" }
    end

    describe "with wrong credentials" do
      before do
        fill_in "Email", with: "e@mail.com"
        fill_in "Password", with: "password"
        click_button submit
      end

      it { should have_content("Sign In") }
      it { should have_error_message "Invalid" }
      it { should_not have_link('Settings') }

      describe "after visiting another page" do
        before { click_link "Home" }

        it { should_not have_error_message "Invalid" }
      end
    end

    describe "with right credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        valid_signin(user)
      end

      it { should have_title(user.name) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "after signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        it { should_not have_link('Sign out') }
        it { should_not have_link('Profile') }
        it { should_not have_link('Settings') }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign In') }
        end
        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "submitting to the destroy action" do
          before { delete user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "visiting the users index" do
          before { visit users_path }
          it { should have_title('Sign In') }
        end
        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title('Sign In') }
        end
        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title('Sign In') }
        end
      end
      describe "in the Microposts controller" do
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
        describe "then signout and signin" do
          before do
            click_link "Sign out"
            visit signin_path
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end
          it { should have_title(user.name) }
        end
      end
    end
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, 
        email: "another@example.com") }
      let(:wrong_users_mp) { FactoryGirl.create(:micropost, 
        user: wrong_user) }
      before do 
        get signin_path
        valid_signin user, no_capybara: true 
      end

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).
          not_to match(full_title('Edit user')) }
          specify { expect(response).
            to redirect_to(root_url) }
          end

          describe "submitting a PATCH request to the Users#update action" do
            before { patch user_path(wrong_user), user: {email: "test@example.com"} }
            specify { expect(response).to redirect_to(root_url) }
          end

          describe "submitting a DELETE request to the Users#destroy action" do
            before { delete user_path(user) }
            specify { expect(response).to redirect_to(root_url) }
          end

          describe "submitting a DELETE request to the Microposts#destroy action" do
            before { delete micropost_path(wrong_users_mp) }
            specify { expect(response).to redirect_to(root_url) }
            it "should not delete others micropost" do
              expect { delete micropost_path(wrong_users_mp) }.
              not_to change(Micropost, :count)
            end
          end
        end
        describe "as non-admin user" do
          let(:user) { FactoryGirl.create(:user) }
          let(:non_admin) { FactoryGirl.create(:user) }

          before do
            visit signin_path
            valid_signin non_admin, no_capybara: true
          end

          describe "submitting a DELETE request to the Users#destroy action" do
            before { delete user_path(user) }
            specify { expect(response).to redirect_to(root_url) }
          end

          describe "submitting an UPDATE request with Users#admin attribute" do
            before { patch user_path(non_admin), 
              { user: FactoryGirl.attributes_for(:user, admin: true) } }

              specify { expect(response).to redirect_to(non_admin) }
              specify { expect(non_admin.reload).not_to be_admin }
            end

            describe "submitting a GET request to the Users#new action" do
              before { get new_user_path }
              specify { expect(response).to redirect_to(root_url) }
            end
            describe "submitting a POST request to the Users#create action" do
              before { post users_path, 
                {user: FactoryGirl.attributes_for(:user, email: "new@example.com")} }
                specify { expect(response).to redirect_to(root_url) }
              end
            end
            describe "as an admin user" do
              let(:admin) { FactoryGirl.create(:admin) }
              before do
                visit signin_path
                valid_signin admin, no_capybara: true
              end
              describe "submitting a DELETE request to the Users#destroy action on self" do
                specify { expect{ delete user_path(admin) }.
                not_to change(User, :count) }
                describe "and" do
                  before do
                    delete user_path(admin)

                  end
                  specify { expect(response).to redirect_to(users_path) } 
                  specify { expect(flash[:danger]).to eq "Admin cannot delete self" }
                end
              end
            end

          end
        end
