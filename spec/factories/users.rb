require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    sequence(:encrypted_password) {|n| "xxxxxx-#{n}@example.com" }
  end
end
