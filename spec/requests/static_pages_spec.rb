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
    # it { should have_selector('h1', text: 'Sample App') }

    # it "should have the content 'Sample App'" do
    #   expect(page).to have_content('Sample App')
    # end

    # it { should have_title full_title }

    # it "should have the default title" do
    #   expect(page).to have_title("#{base_title}")
    # end
    it { should_not have_title full_title('Home') }
    # it "should not have a custom title" do
    #   expect(page).not_to have_title("| Home")
    # end
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
