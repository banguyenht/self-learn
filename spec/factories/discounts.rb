FactoryBot.define do
  factory :discount do
    name { Faker::Name.name }
    value { rand(10..20) }
    unit { [0, 1].sample }
  end
end
