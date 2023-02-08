class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  validates_presence_of :quantity, :unit_price
  validates_numericality_of :quantity, :unit_price
end
