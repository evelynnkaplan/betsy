
class ReviewsController < ApplicationController
  before_action :find_product

  def new
    if current_merchant  && @product
      if @product.merchant_id == current_merchant.id
        flash[:status] = :error
        flash[:message] = "You cannot review your own products"
        redirect_back(fallback_location: root_path)
        return
      end
    end

    @review = Review.new
  end
      
  def create
    @review = Review.new(review_params)
    @review.product = @product

    if @review.save
      flash[:status] = :success
      flash[:message] = "Your review has been successfully added."
      redirect_to product_path(params[:product_id])
    else 
      flash[:status] = :error
      flash[:message] = "Your review could not be generated."
      render :new, status: :bad_request
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def find_product
    @product = Product.find_by(id: params[:product_id])

    unless @product
      head :not_found
      return 
    end
  end
end
