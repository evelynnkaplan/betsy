class OrdersController < ApplicationController
  def index

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
