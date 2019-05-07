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
  end

  def create
  end

  def edit
  end

  def update
  end

  def view_cart
    @order_items = current_order.order_items
  end
end
