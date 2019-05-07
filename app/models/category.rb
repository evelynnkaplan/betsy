class Category < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, uniqueness: true, presence: true
  before_save :lowercase_name
end

def self.lowercase_name
  return self.name.downcase!
end