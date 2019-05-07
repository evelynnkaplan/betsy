require "pry"

class OrdersController < ApplicationController
  def index
    if session[:merchant_id]
      @merchant = Merchant.find_by(id: session[:merchant_id])
      @orders = @merchant.orders
    else
      flash[:status] = :error
      flash[:message] = "You don't have permission to see a list of orders. Please log in."
      redirect_to root_path
    end
  end

  def show
    @order = Order.find_by(id: params[:id])

    if !@order
      flash[:status] = :error
      flash[:message] = "There is no order to view. Add an item to your shopping cart to start an order."
      redirect_to products_path
    elsif @order && (!@order.merchants || !@order.merchants.include?(Merchant.find(current_merchant.id)))
      flash[:status] = :error
      flash[:message] = "You don't have anything to do with that order. Mind your own business."
      redirect_to dashboard_path
    elsif @order.status == "pending"
      flash[:status] = :error
      flash[:message] = "The order is still pending. Check back for details after paying."
      redirect_to view_cart_path
    end
  end

  def edit
    @order = current_order
  end

  def update
    # checkout
  end

  def confirmation
  end

  def view_cart
    @order_items = current_order.order_items
  end

  private

  def order_params
    
  end
end
