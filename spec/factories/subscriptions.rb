FactoryGirl.define do
  factory :subscription do
    user
    plan
    email
    sequence(:key) {|n| "123#{n}-456#{n}-789#{n}"}
  end
end
