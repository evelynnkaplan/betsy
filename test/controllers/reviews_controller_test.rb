require "test_helper"


describe ReviewsController do
  let(:product_id) {Product.first.id}
  let(:review_data) { { review: { rating: 5, comment: "The best information." } } }

  describe "new" do 
    it "loads the add review form" do
      get new_product_review_path(product_id)

      must_respond_with :ok
    end

    it "responds with 404 if review request for nonexistant product" do 
      bad_id = Product.last.id + 1

      get new_product_review_path(bad_id)

      must_respond_with :not_found
    end

    it "will not allow a merchant to review their own product" do 
      product = Product.first 
      merchant = product.merchant 
      perform_login(merchant)

      get new_product_review_path(product.id)

      check_flash(:error)
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

    it "does not create a review with missing required rating" do 
      review_data[:review][:rating] = 0

      expect {
        post product_reviews_path(product_id), params: review_data
      }.wont_change "Review.count"

      check_flash(:error)
      must_respond_with  :bad_request
    end
  end
end
