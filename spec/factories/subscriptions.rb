require 'faker'

FactoryGirl.define do
  factory :subscription do
    association :user
    association :plan
    #sequence(:plan_id)
    email { Faker::Internet.email }
    sequence(:key) {|n| "123#{n}-456#{n}-789#{n}"}
  end
end
