class Order < ApplicationRecord
  has_many :order_items
  validates :order_items, presence: true
  validates :name_on_card, :email, :credit_card, :cvv, :card_exp, :billing_zip, presence: true
  validates :status, inclusion: {in: [nil, "pending", "paid", "complete", "cancelled"]}
  before_save :update_total
  before_create :update_status

  def calculate_total
    self.order_items.collect { |item| item.product.price * item.quantity }.sum
  end

  def merchants
    merchant_list = []
    self.order_items.each do |item|
      if !merchant_list.include?(item.product.merchant)
        merchant_list << item.product.merchant
      end
    end
    return merchant_list
  end

  def sold_by_merchant(merch)
    merch_items = []
    self.order_items.each do |item|
      if item.product.merchant == merch
        merch_items << item
      end
    end
    return merch_items
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
