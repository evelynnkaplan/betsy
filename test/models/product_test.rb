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
      product.name = " "
      empty_name = product.save

      # Assert not ""
      expect(empty_name).must_equal false
      expect(product.errors.messages).must_include :name
      product.reload

      # Arrange & Assert uniqueness
      used_name = product.name
      new_product = Product.new(name: used_name, merchant: merchants(:merch_one), price: 10)
      new_product.save

      expect(new_product.valid?).must_equal false
      expect(new_product.errors.messages).must_include :name
    end

    it "validates price is present and greater than zero" do 
      #Arrange edge cases
      product.price = 0
      result = product.save

      #Assert
      expect(result).must_equal false
      expect(product.errors.messages).must_include :price

      # Arrange and Act
      product.price = "A"
      string_result = product.save
      
      expect(string_result).must_equal false
      expect(product.errors.messages).must_include :price

      # Arrange & Act
      product.price = 100
      valid_result = product.save
      
      # nominal case
      expect(valid_result).must_equal true
    end
  end

  describe "relationships" do 
    it "belongs to a merchant" do 
      expect(product).must_respond_to :merchant
      expect(product.merchant).must_equal merchants(:merch_one)
    end

    it "cannot be instantiated without a merchant" do
      product.merchant_id = nil
      result = product.save

      expect(result).must_equal false
      expect(product.errors.messages).must_include :merchant
    end

    it "has one or many categories" do 
      # save for once join table is created...
    end

    it "has orders" do 
      # save for after order model is created
    end
  end

  describe "custom methods" do 
    # if any, add tests here
  end
end
