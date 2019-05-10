require "test_helper"
require 'pry'

describe Product do
  let(:product) { products(:product_one) }

  describe "instantiation" do
    it "can be instantiated" do
      tst_product = Product.new(name: "Test", price: 10, stock: 12, merchant_id: merchants(:merch_one).id, )
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

    it "must have a stock > 0 upon instantiation" do
      product.stock = 0

      # It fails with invalid data
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :stock

      # It passes with valid data
      product.reload
      expect(product.valid?).must_equal true
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
  end
  
    describe "categories" do 
      it "has many categories" do
        government_category = categories(:government) # this needs work

        expect(government_category.products).must_include product
      end

      it "can have multiple categories" do
        expect(product.categories.count).must_equal 2
      end

      it "when purchased it becomes an order_item" do
        order_item = order_items(:oi_one)

        expect(product.order_items).must_include order_item
      end
    end

    describe "reviews" do 
      let(:t_prod) { Product.create!(name: "Test Product1",
                                       description: "What does she store in all 752 rooms at Buckingham palace?",
                                       price: 10000,
                                       stock: 100,
                                       img_url: 'images/testimg.jpg',
                                       merchant: merchants(:merch_one),
                                       categories: [categories(:government), categories("celebrities")],
                                      )
                      }
      let(:review1) { Review.create!(rating: 5, product_id: t_prod.id) }
      let(:review2) { Review.create!(rating: 5, product_id: t_prod.id )}

      it "has reviews" do
        t_prod.reviews.push(review1, review2)

        expect(t_prod.reviews.count).must_equal 2

      end
    end

  describe "custom methods" do
    describe "related products" do
      it "returns an array of products even if less than 6 total products" do
        related = product.related_products

        expect(related).must_be_kind_of Array
        expect(related.length).must_equal (Product.count - 1)
      end

      it "returns an array of only 5 products if are more than 5 products" do
        merchant = merchants(:merch_one)

        Product.create(name: "A test product", merchant_id: merchant.id, price: 6, stock: 1)
        Product.create(name: "Another product", merchant_id: merchant.id, price: 6, stock: 1)
        Product.create(name: "A new other product", merchant_id: merchant.id, price: 6, stock: 1)

        expect(Product.count).must_be :>, 5

        related = product.related_products

        expect(related).must_be_kind_of Array
        expect(related.length).must_equal 5
      end
    end

    describe "average rating" do 
      let(:avg_prod) { Product.create!(name: "Test Product1",
                                       description: "What does she store in all 752 rooms at Buckingham palace?",
                                       price: 10000,
                                       stock: 100,
                                       img_url: 'images/testimg.jpg',
                                       merchant: merchants(:merch_one),
                                       categories: [categories(:government), categories("celebrities")],
                                      )
                      }
      it "shows the average rating for a product" do 
        avg_prod.reviews << Review.create!(rating: 1, product_id: avg_prod.id)
        avg_prod.reviews << Review.create!(rating: 5, product_id: avg_prod.id )
        
        expect(avg_prod.reviews.count).must_equal 2
        expect(avg_prod.average_rating).must_equal 3
      end
    end
  end
end
