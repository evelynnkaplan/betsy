require "test_helper"

describe ReviewsController do
  let(:review) { Review.new(comment: "This is a test review")}
  describe "new" do 
    it "loads the add review form" do
      get new_review_path

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
