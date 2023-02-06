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
end
