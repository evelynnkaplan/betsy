class CategoriesController < ApplicationController

  def index
    @categories = Category.all 
  end

  def new
    if current_merchant
      @category = Category.new
    else
      require_login
    end
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:status] = :success
      flash[:message] = "Successfully added your category to the site."
      redirect_to categories_path
    else
      flash[:status] = :error
      flash[:message] = "Unable to add your category to the site."
      render :new, status: :bad_request
    end
    
    
  end
  
  def show
    @category = Category.find_by(id: params[:id])

    unless @category
      head :not_found
      return
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end


# check session for merchant id. check if order.prod.map{merchant_id} includes session[:id] else not authorized, order.prod.where(merchant_id == session[:id])