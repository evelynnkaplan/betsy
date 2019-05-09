class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_and_belongs_to_many :categories
  belongs_to :merchant
  validates :name, presence: true, uniqueness: true
  validates :price, :stock, presence: true, numericality: { greater_than: 0 }

  def related_products
    related_products = []
    if Product.count >= 6
      until related_products.length == 5
        product = Product.all.sample

        if related_products.include?(product) == false && product != self
          related_products.push(product)
        end
      end
    else
      Product.all.each do |product|
        if product != self
          related_products.push(product)
        end
      end
    end

    return related_products
  end

  def average_rating
    average = 0
    no_of_reviews = self.reviews.count
    if average == 0 
      return 0
    else
      self.reviews.each do |review|
        total_ratings += review.rating
      end
      return average = total_ratings / no_of_reviews
    end
  end
end
