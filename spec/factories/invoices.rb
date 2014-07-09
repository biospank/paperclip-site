FactoryGirl.define do
  factory :invoice do
    sequence(:customer) {|n| Customer.new(id: n)}
    sequence(:subscription) {|n| Subscription.new(id: n)}
    sequence(:number)
    date Date.today
  end
end
