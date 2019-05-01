require "test_helper"

describe Product do
  let(:product) { products(:product_one)}

  describe "instantiation" do 
    it "can be instantiated" do
      
      expect(product.valid?).must_equal true
    end

    it "has all attributes" do
      product_attribute_array.each do |field|
        expect(product).must_respond_to field
      end
    end

    it "validates present and unique names" do 
      # Arrange
      nil_product = Product.new(name: nil)
      empty_name = Product.new(name: "")

      # Assert presence
      expect(nil_product.valid?).must_equal false
      expect(empty_name.valid?).must_equal false

      # Arrange & Assert uniqueness
      used_name = product.name
      new_product = Product.new(name: used_name)

      expect(new_product.valid?).must_equal false
    end

    it "validates price is present and greater than zero" do 
      #Arrange edge cases
      product.price = 0
      result = product.save

      #Assert
      expect(result).must_equal false

      # Arrange and Act
      product.price = "A"
      string_result = product.save
      
      expect(string_result).must_equal false

      # Arrange & Act
      product.price = 100
      valid_result = product.save
      
      # nominal case
      expect(valid_result).must_equal true
    end
  end

  describe "relationships" do 
    it "must belong to a merchant" do 
    end

    it "has one or many categories" do 
    end
  end

  describe "custom methods" do 
  end
end
