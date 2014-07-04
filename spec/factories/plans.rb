FactoryGirl.define do
  factory :plan do
    name ["Trimestrale", "Semestrale", "Annuale"].sample
    months [3, 6, 12].sample
    price [27.0, 54.0, 108.0].sample
    discount [nil, 5, 10]
  end
end
