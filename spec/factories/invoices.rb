FactoryGirl.define do
  factory :invoice do
    customer
    subscription
    # sequence(:customer) {|n| build(:customer, id: n)}
    # sequence(:subscription) {|n| build(:subscription, id: n)}
    sequence(:number)
    date Date.today
  end
end
