require 'rails_helper'

RSpec.describe "StaticPages", :type => :request do
  # let(:base_title) {"Ruby on Rails Tutorial Sample App"}
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title full_title(page_title) }
  end

  describe "Layout" do
    it "should have the right links" do
      visit root_path
      within('#main') do
        click_link "About"
      end
      expect(page).to have_title full_title('About')
      within('#main') do
        click_link "Help"
      end
      expect(page).to have_title full_title('Help')
      within('#main') do
        click_link "Contacts"
      end
      expect(page).to have_title full_title('Contacts')
      within('#main') do
        click_link "Home"
      end
      expect(page).to have_title full_title('')
      click_link "Sign up now!"
      expect(page).to have_title full_title('Sign up')
    end
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title full_title('Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "aaa")
        FactoryGirl.create(:micropost, user: user, content: "bbb")
        visit signin_path
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", 
            text: item.content)
        end
      end

      describe "sidebar" do
        let(:microposts_count) do
          user.microposts.count.to_s+" "+
            'micropost'.pluralize(user.microposts.count)
        end
        it { should have_selector('section h1', text: user.name) }
        it { should have_selector('span', text: microposts_count) }
        
        describe "JS letters counter" do
          it { should have_selector('#letters_counter', 
            text: '140 letters left') }
          # NEED FIREFOX TO WORK
          # describe "when typing", js: true do
          #   before { fill_in "micropost_content", 
          #    with: "123" }
          #   it { should have_selector('#letters_counter', 
          #   text: '137 letters left') }
          #   specify { expect(page).to have_content('137') }
          # end
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"

    # it { should have_selector('h1', text: 'Help') }
    # it { should have_title full_title('Help') }
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"

    # it {should have_selector('h1', text: 'About')}
    # it {should have_title full_title('About')}
  end

  describe "Contacts page" do
    before { visit contacts_path }
    let(:heading) { 'Contacts' }
    let(:page_title) { 'Contacts' }

    it_should_behave_like "all static pages"

    # it {should have_selector('h1', text: 'Contacts')}
    # it {should have_title full_title('Contacts')}
  end
end
