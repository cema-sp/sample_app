require 'rails_helper'

RSpec.describe "MicropostPages", :type => :request do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before do
    user.microposts.create(content: 'test')
    visit signin_path
    valid_signin user
  end

  describe "micropost creation" do
    before { visit root_path }
    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button "Post" }.
          not_to change(Micropost, :count)
      end
      describe "error messages" do
        before { click_button "Post" }
        specify { expect(user.microposts.count).to eq(1) }
        it { should have_error_message 'error' }
        it { should have_selector('.microposts') }
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: 'aaa' }
      it "should create a micropost" do
        expect { click_button "Post" }.
          to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    describe "as correct user" do
      before { visit root_path }
      it "should delete a micropost" do
        expect { first('.microposts li').click_link "delete" }.
          to change(Micropost, :count).by(-1)
      end
    end
  end
end
