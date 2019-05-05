require "test_helper"

describe Review do
  let(:review) { Review.new(rating: 5, product_id: Product.all.sample.id) }
  describe "validations" do 
    it "can be instantiated" do 
      expect(review.valid?).must_equal true
      expect(review.errors.messages).must_be_empty
    end

    it "responds to its fields" do 
      ["rating", "product_id", "comment"].each do |field|
        expect(review).must_respond_to field
      end
    end

    it "validates a 1-5 rating" do 
      review.rating = 0

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
      
      review.rating = 7

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
    end
  end

  describe "relationships" do 
    it "requires a product_id reference" do 
      review.rating = 1
      review.product_id = nil

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :product
    end
  end

  # describe "custom methods" do 
  #   it " " do 
      
  #   end
  # end
end
