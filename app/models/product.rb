class Product < ApplicationRecord
  has_many :reviews
  has_and_belongs_to_many :categories
  belongs_to :merchant
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
