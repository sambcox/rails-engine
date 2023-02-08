FactoryBot.define do
  factory :invoice do
    status { 'shipped' }
    merchant_id { Merchant.all.shuffle.shuffle.first.id }
    customer_id { Customer.all.shuffle.shuffle.first.id }
  end
end