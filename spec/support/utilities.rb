include ApplicationHelper

def valid_signin(user, options={})
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, 
      User.encrypt(remember_token))
  else
    fill_in "Email", with: user.email.upcase
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('.alert.alert-danger', text: message)
  end
end