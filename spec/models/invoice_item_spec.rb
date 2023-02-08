require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'Relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:transactions).through(:invoice) }
  end

  describe 'Validations' do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of :quantity }
    it { should validate_numericality_of :unit_price }
  end
end
