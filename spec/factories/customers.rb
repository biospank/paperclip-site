FactoryGirl.define do
  factory :customer do
    user
    name "Canistracci Oil S.r.l."
    sequence(:tax_code) {|n| "12345678910"}
    address "Via della Camilluccia 13"
  end
end
