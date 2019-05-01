class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    product_hash = {
      description: params[:description],
      name: params[:name],
      price: params[:price],
      stock: params[:stock],
      img_url: params[:img_url],
      # take a second look at this later
      merchant_id: params[:merchant_id] ||= Merchant.find_by(username: params[:merchant]),
    }

    product = Product.new(product_hash)
  end
end
