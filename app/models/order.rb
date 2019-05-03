class Order < ApplicationRecord
  has_many :order_items
  
  validates :order_items, presence: true
  # a merchant has many orders through products
  # a product 
end
