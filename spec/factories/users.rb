require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    sequence(:encrypted_password) {|n| "xxxxxx-#{n}@example.com" }

    factory :admin do
      admin true
    end
  end
end
