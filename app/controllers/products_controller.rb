class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
    if !@product
      flash[:error] = "No product with that ID found."
      redirect_to products_path
    end
  end

  def new
    @product = Product.new
  end

  def create
    product = Product.new(product_params)

    successful = product.save

    if successful
      flash[:success] = "Product named #{product.name} successfully created with ID number #{product.id}."
      redirect_to products_path
    else
      flash[:error] = "Error saving product: #{product.errors.messages}"
      redirect_to products_path
    end
  end

  def edit
    if !@product
      flash[:error] = "No product with that ID found."
      redirect_to products_path
    end
  end

  def update
    if !@product
      flash[:error] = "No product with that ID found."
      redirect_to products_path
    else
      @product.update!(product_hash)
      flash[:success] = "Successfully edited product #{@product.id}."
      redirect_to product_path(@product.id)
    end
  end

  def destroy
    if !@product
      flash[:error] = "No product with that ID found."
      redirect_to products_path
    else
      successful = @product.destroy
      if successful
        flash[:success] = "Product #{@product.name} with ID number #{@product.id} deleted."
      else
        flash[:error] = "There was an error: #{@product.errors.messages}."
      end
    end
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    return params.require(:product).permit(:description, :name, :price, :stock, :img_url, :merchant_id)
  end
end
