class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def self.find_all_by_name(name)
    Item.where('lower(name) LIKE ?', "%#{name.downcase}%")
        .or(Item.where('lower(description) LIKE ?', "%#{name.downcase}%"))
        .order(Arel.sql('lower(name)'))
  end
end