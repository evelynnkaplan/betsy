class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def merchant_product_index
    @merchant = Merchant.find_by(id: params[:id])
    @products = Product.where(merchant_id: @merchant.id)
  end

  def category_product_index
    @category = Category.find_by(id: params[:id])
    @products = Product.where(category_id: @category.id)
  end

  def show
    if !@product
      flash[:status] = :error
      flash[:message] = "No product with that ID found."
      redirect_to products_path
    end
  end

  def new
    if session[:merchant_id]
      @product = Product.new
    else
      flash[:status] = :error
      flash[:message] = "You don't have permission to create a new product. Please log in."
      redirect_to root_path
    end
  end

  def create
    if session[:merchant_id]
      product = Product.new(product_params)
      product.merchant_id = session[:merchant_id]

      successful = product.save

      if successful
        flash[:status] = :success
        flash[:message] = "Product named #{product.name} successfully created with ID number #{product.id}."
        redirect_to products_path
      else
        flash[:status] = :error
        flash[:message] = "Error saving product: #{product.errors.messages}"
        redirect_to products_path
      end
    else
      flash[:status] = :error
      flash[:message] = "You don't have permission to create a new product. Please log in."
      redirect_to root_path
    end
  end

  def edit
    if !@product
      flash[:status] = :error
      flash[:message] = "No product with that ID found."
      redirect_to products_path
    elsif !session[:merchant_id]
      flash[:status] = :error
      flash[:message] = "You don't have permission to edit product #{@product.id}. Please log in."
      redirect_to root_path
    end
  end

  def update
    if !@product
      flash[:status] = :error
      flash[:message] = "No product with that ID found."
      redirect_to products_path
    else
      @product.update!(product_params)
      flash[:status] = :success
      flash[:message] = "Successfully edited product #{@product.id}."
      redirect_to product_path(@product.id)
    end
  end

  def destroy
    if !@product
      flash[:status] = :error
      flash[:message] = "No product with that ID found."
      redirect_to products_path
    elsif session[:merchant_id]
      successful = @product.destroy
      if successful
        flash[:status] = :success
        flash[:message] = "Product #{@product.name} with ID number #{@product.id} deleted."
        redirect_to products_path
      else
        flash[:status] = :error
        flash[:message] = "There was an error: #{@product.errors.messages}."
        redirect_to products_path
      end
    else
      flash[:status] = :error
      flash[:message] = "You don't have permission to delete product #{@product.id}. Please log in."
      redirect_to root_path
    end
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    return params.require(:product).permit(:description, :name, :price, :stock, :img_url, :merchant_id, category_ids: [])
  end
end
