class Order < ApplicationRecord
  has_many :order_items
  # validates :order_items, presence: true
  validates :status, inclusion: {in: [nil, "pending", "paid", "complete", "canceled"]}
  before_save :update_total
  before_create :update_status

  def calculate_total
    self.order_items.collect { |item| item.product.price * item.quantity }.sum
  end

  private

  def update_status
    unless self.status
      self.status = "pending"
    end
  end

  def update_total
    self.total_price = calculate_total
  end
end
