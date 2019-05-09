class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :quantity, numericality: { only_integer: true, greater_than: 0}

  def max_quantity
    return false if self.product.stock < self.quantity 
    return true 
  end
end
