FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "User #{n}"}
    sequence(:email) {|n| "user-#{n}@example.com" } 
    password "password"
    password_confirmation "password"
    factory :admin do
      admin true
    end
  end
  factory :micropost do
    content "Lorem ipsum dolor ales"
    user
  end
end