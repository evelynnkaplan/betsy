require "test_helper"
# require 'pry'

describe ReviewsController do
  let(:product_id) {Product.all.sample}
  let(:review_data) { { review: { rating: 5, comment: "The best information." } } }

  describe "new" do 
    it "loads the add review form" do
      get new_product_review_path(product_id)

      must_respond_with :ok
    end

    it "will not allow a merchant to review their own product" do 
      merchant = merchants(:merch_one)
      perform_login(merchant)
      
      product = Product.find_by(merchant_id: merchant.id)

      get new_product_review_path(product_id)

      # check_flash(:error)
      must_respond_with :redirect
    end 
  end

  describe "create" do 
    it "creates a new review successfully" do 
      review_data

      expect {
        post product_reviews_path(product_id), params: review_data
      }.must_change "Review.count", +1
        
      check_flash
      must_respond_with :redirect
      must_redirect_to product_path(product_id)
    end

    it "requires a rating for a review" do 
      review_data[:review][:rating] = 0

      expect {
        post product_reviews_path(product_id), params: review_data
      }.wont_change "Review.count"

      check_flash(:error)
      must_respond_with  :bad_request
    end
  end
end
