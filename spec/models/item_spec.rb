RSpec.describe Item do
  describe 'Relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :description }
  end

  describe 'Class Methods' do
    describe '#max_item_price' do
      it 'returns the maximum item price' do
        create_list(:merchant, 3)
        create_list(:item, 5, unit_price: Faker::Number.within(range: 100.00..1000.00))
        create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.99))
        max_item_price = Item.maximum(:unit_price)

        expect(Item.max_item_price).to eq(max_item_price)
      end
    end

    describe '#find_all_by_name' do
      it 'returns all items by name given a string' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, name: 'Jordan 191')
        lost_items = create_list(:item, 5, name: "Ferrari 641")

        expect(Item.find_all_by_name('Jordan 191').sort).to eq(findable_items.sort)
      end

      it 'returns all items by name given partial string' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, name: 'Jordan 191')
        lost_items = create_list(:item, 5, name: "Ferrari 641")

        expect(Item.find_all_by_name('Jord').sort).to eq(findable_items.sort)
      end

      it 'returns all items by name case insensitive' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, name: 'Jordan 191')
        lost_items = create_list(:item, 5, name: "Ferrari 641")

        expect(Item.find_all_by_name('JOrDAn 191').sort).to eq(findable_items.sort)
      end

      it 'returns all items by name given description' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, description: 'Jordan 191')
        lost_items = create_list(:item, 5, description: "Ferrari 641")

        expect(Item.find_all_by_name('Jordan 191').sort).to eq(findable_items.sort)
      end

      it 'returns all items by name given partial description' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, description: 'Jordan 191')
        lost_items = create_list(:item, 5, description: "Ferrari 641")

        expect(Item.find_all_by_name(' 191').sort).to eq(findable_items.sort)
      end

      it 'returns all items by name given description and is case insensitive' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, description: 'Jordan 191')
        lost_items = create_list(:item, 5, description: "Ferrari 641")

        expect(Item.find_all_by_name('OrDa').sort).to eq(findable_items.sort)
      end

      it 'returns an empty array if no items are found' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, description: 'Jordan 191')
        lost_items = create_list(:item, 5, name: "Ferrari 641")

        expect(Item.find_all_by_name('F2004').sort).to eq([])
      end
    end

    describe '#find_all_by_price' do
      it 'returns all items given a minimum price' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 100.00..1000.00))
        lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.99))

        expect(Item.find_all_by_price(100, nil).sort).to eq(findable_items.sort)
      end

      it 'returns all items given a maximum price' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..250.00))
        lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 251.00..1000.00))

        expect(Item.find_all_by_price(nil, 250).sort).to eq(findable_items.sort)
      end

      it 'returns all items given a minimum and maximum price' do
        create_list(:merchant, 3)
        findable_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 100.00..500.00))
        lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
        lost_items_2 = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

        expect(Item.find_all_by_price(100, 500).sort).to eq(findable_items.sort)
      end

      it 'returns an empty array if no items are found' do
        create_list(:merchant, 3)
        lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
        lost_items_2 = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

        expect(Item.find_all_by_price(100, 500)).to eq([])
      end
    end
  end
end
