class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.find_by_name(name)
    Merchant.where('lower(name) LIKE ?', "%#{name.downcase}%").order(Arel.sql('lower(name)')).limit(1).first
  end
end