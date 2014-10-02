require 'rails_helper'

RSpec.describe "StaticPages", :type => :request do
  # let(:base_title) {"Ruby on Rails Tutorial Sample App"}
  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_content('Sample App') }
    # it "should have the content 'Sample App'" do
    #   expect(page).to have_content('Sample App')
    # end
    it { should have_title full_title }
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
    it { should have_content('Help') }
    it { should have_title full_title('Help') }
  end

  describe "About page" do
    before { visit about_path }
    it {should have_content('About')}
    it {should have_title full_title('About')}
  end

  describe "Contacts page" do
    before { visit contacts_path }
    it {should have_content('Contacts')}
    it {should have_title full_title('Contacts')}
  end
end
