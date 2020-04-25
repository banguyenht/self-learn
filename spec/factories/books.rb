FactoryBot.define do
  factory :book do
    title { Faker::Name.name }
    price { 1 }
    author
  end
end
