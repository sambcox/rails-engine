FactoryBot.define do
  factory :merchant do
    name { Faker::Sports::Football.team }
  end
end