class ReviewsController < ApplicationController
  
  def new
    @review = Review.new
  end
      
  def create
    if current_merchant
      review = Review.products.where(merchant_id: current_merchant.id)
      if review.empty?
        @review = Review.new(review_params)
      else
        flash[:status] = :error
        flash[:message] = "You cannot review your own products"
      end
    else
      @review = Review.new(review_params)
    end

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

  end

  private

  def review_params
    params.require(:review).permit(:comment)
  end
end
