FactoryGirl.define do
  sequence(:email) {|n| "person-#{n}@example.com" }

  factory :user do
    email
    sequence(:encrypted_password) {|n| "xxxxxx-#{n}@example.com" }
  end
end
