class Product < ApplicationRecord
  belongs_to :merchant
  validates :name, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
