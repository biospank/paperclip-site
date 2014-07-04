FactoryGirl.define do
  factory :contact do
    name "Fabio Petrucci"
    sequence(:email) {|n| "fabio.petrucci#{n}@gmail.com"}
    message "Test message"
  end
end
