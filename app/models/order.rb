class Order < ApplicationRecord
  has_many :order_items
  validates :order_items, :length { :minimum => 1 } 
  # a merchant has many orders through products
  # a product 
end
