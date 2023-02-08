FactoryBot.define do
  factory :invoice_item do
    unit_price { Faker::Number.within(range: 1.0..1000.0) }
    quantity { Faker::Number.within(range: 1..10) }
    item_id { Item.all.shuffle.shuffle.first.id }
    invoice_id {
      invoice = Invoice.all.shuffle.shuffle.first
      until !invoice.items.map { |item| item.id }.include?(item_id) do
        invoice = Invoice.all.shuffle.shuffle.first
      end
      invoice.id
    }
  end
end