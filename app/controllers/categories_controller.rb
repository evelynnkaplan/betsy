class CategoriesController < ApplicationController

  def index
    @categories = Category.all 
  end

  def new
    require_login
    @category = Category.new
  end

  def create
    require_login

    @category = Category.new(category_params)
    @category.save

    if @category
      flash[:status] = :success
      flash[:message] = "Successfully added your category to the site."
    else
      flash[:status] = :error
      flash[:message] = "Unable to add your category to the site."
    end
    
    redirect_to categories_path
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