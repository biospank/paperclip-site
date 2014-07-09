FactoryGirl.define do
  factory :customer do
    sequence(:user_id)
    name "Canistracci Oil S.r.l."
    sequence(:tax_code) {|n| "12345678910"}
    address "Via della Camilluccia 13"
    cap 20060
    city "Gessate"
  end

end
