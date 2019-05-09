class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.paginate(page: params[:page], per_page: 12)
  end

  def merchant_product_index
    @merchant = Merchant.find_by(id: params[:id])

    if !@merchant
      flash[:status] = :error
      flash[:message] = "No merchant with that ID found."
      redirect_to products_path
    else
      @products = Product.where(merchant_id: @merchant.id)
    end
  end

  def category_product_index
    @category = Category.find_by(id: params[:id])
    if !@category
      flash[:status] = :error
      flash[:message] = "No category with that ID found."
      redirect_to products_path
    elsif @category.name == "hidden"
      flash[:status] = :error
      flash[:message] = "Illegal request"
      redirect_to products_path
    else
      @products = Product.includes(:categories).where(:categories => {:id => @category.id}).all
    end
  end

  def show
    unless @product
      flash[:status] = :error
      flash[:message] = "No product with that ID found."
      redirect_to products_path
    end
    @order_item = current_order.order_items.new
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
    elsif session[:merchant_id] != @product.merchant_id
      flash[:status] = :error
      flash[:message] = "You cannot edit another merchant's products"
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if !@product
      flash[:status] = :error
      flash[:message] = "No product with that ID found."
      redirect_to products_path
    elsif !session[:merchant_id]
      flash[:status] = :error
      flash[:message] = "You don't have permission to edit product #{@product.id}. Please log in."
      redirect_to root_path
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
