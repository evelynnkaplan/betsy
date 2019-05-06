require "test_helper"

describe Category do
  let(:category) { Category.new(name: "Taco Cat") }

  describe "validations" do 
    it "must be valid" do
      value(category).must_be :valid?
    end

    it "doesn't allow repeat names" do 
      category.save
      used_name = category.name
      new_categ = Category.new(name: used_name)

      expect(new_categ.valid?).must_equal false
    end
  end

  describe "relationships" do 
    it "can have many products" do 
      product = Product.first
      product_2 = Product.last
      category.products << product
      category.products << product_2

      expect(category).must_respond_to :products
      expect(category.products.count).must_equal 2
    end
  end
end
