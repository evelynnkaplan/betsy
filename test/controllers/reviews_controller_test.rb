require "test_helper"

describe ReviewsController do
  let(:review) { Review.new(comment: "This is a test review")}
  let(:product_id) {Product.all.sample}
  describe "new" do 
    it "loads the add review form" do
      get new_product_review_path(product_id)

      must_respond_with :ok
    end
  end

  describe "create" do 
    it "creates a new review successfully" do 
      review_data = {
        review: {
          rating: 5, 
          comment: "The best information."
        }
      }

      expect {
        post product_reviews_path(product_id), params: review_data
      }.must_change "Review.count", +1
        
      check_flash
      
      must_respond_with :redirect
      must_redirect_to product_path(product_id)

    end

    it "will not allow a merchant to review their own product" do 
      
    end 
  end
end
