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
      
    end

    it "will not allow a merchant to review their own product" do 
      
    end 
  end
end
