FactoryGirl.define do
  factory :customer do
    association(:user)
    name { Faker::Company.name }
    tax_code { Faker::Number.number(11) }
    address { Faker::Address.street_address }
    cap { Faker::Address.zip_code.to_s }
    city { Faker::Address.city }
  end

end
