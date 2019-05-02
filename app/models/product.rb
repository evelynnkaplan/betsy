class Product < ApplicationRecord
  has_many :reviews
  belongs_to :merchant
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
