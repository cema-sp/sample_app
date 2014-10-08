FactoryGirl.define do
  factory :user do
    name "User001"
    email "email@example.com"
    password "password"
    password_confirmation "password"
  end
end