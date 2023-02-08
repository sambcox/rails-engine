require 'rails_helper'

RSpec.describe Merchant do
  describe 'Relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
  end

  describe 'Class Methods' do
    it 'can find a merchant by name' do
      create_list(:merchant, 3)
      merchant = Merchant.first

      expect(Merchant.find_by_name(merchant.name)).to eq(merchant)
    end

    it 'can find a merchant by name given only a partial name' do
      create_list(:merchant, 3)
      merchant = Merchant.first
      partial_name = merchant.name.chars[1..3].join

      expect(Merchant.find_by_name(partial_name)).to eq(merchant)
    end

    it 'returns nil if merchant is not found' do
      create_list(:merchant, 3)
      merchant = Merchant.first

      expect(Merchant.find_by_name('F2004')).to eq(nil)
    end
  end
end