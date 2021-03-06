
class Merchant < ApplicationRecord
  has_many :products
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.email = auth_hash["info"]["email"]
    merchant.username = auth_hash["info"]["nickname"]

    return merchant
  end

  def orders
    order_list = []
    self.products.each do |prod|
      prod.order_items.each do |item|
        if !order_list.include?(item.order)
          order_list << item.order
        end
      end
    end
    return order_list
  end

  def sold_order_items
    orders_with_items = {}
    self.orders.each do |order|
      oi_list = []
      order.order_items.each do |oi|
        if oi.product.merchant == self
          oi_list << oi
        end
        orders_with_items[order.id] = oi_list
      end
    end
    return orders_with_items
  end

  def total_revenue
    paid_orders = self.orders
    paid_revenue = 0

    paid_orders.each do |order|
      order.order_items.each do |oi|
       product = Product.find_by(id: oi.product_id)
       paid_revenue += (product.price * oi.quantity)
      end
    end
    return paid_revenue
  end
end
