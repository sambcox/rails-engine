FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::TvShows::Community.quotes }
    unit_price { Faker::Number.within(range: 1.0..1000.0) }
    merchant_id { Merchant.all.shuffle.shuffle.first.id }
  end
end