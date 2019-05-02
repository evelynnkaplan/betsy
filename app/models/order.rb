class Order < ApplicationRecord
  has_many :order_items

  # a merchant has many orders through products
  # a product 
end
