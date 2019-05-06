class ReviewsController < ApplicationController
  before_action :find_product

  def new
    current_merchant
    if @product.merchant_id == current_merchant.id
      flash[:status] = :error
      flash[:message] = "You cannot review your own products"
      return redirect_back(fallback_location: root_path)
    end

    @review = Review.new
  end
      
  def create
    @review = Review.new(review_params)

    if @review.save
      flash[:status] = :success
      flash[:message] = "Your review has been successfully added."
      redirect_to product_path(session[:product_id])
    else 
      flash[:status] = :error
      flash[:message] = "Your review could not be generated."
      render :edit, status: :bad_request
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment)
  end

  def find_product
    @product = Product.find_by(id: params[:product_id])
  end
end
