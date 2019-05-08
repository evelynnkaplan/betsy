require "pry"

class OrderItemsController < ApplicationController
  def create
    @order = current_order
    @item = @order.order_items.new(item_params)
    if @order.save
      flash[:status] = :success
      flash[:message] = "Item successfully added to cart"

      session[:order_id] = @order.id
      redirect_to products_path
    else
      flash[:status] = :error
      flash[:message] = "Order cannot be saved: #{@order.errors.messages}"
      redirect_back(fallback_location: products_path)
    end
  end

  def update
  end

  def destroy
    @order = current_order
    @item = @order.order_items.find_by(id: params[:id])
    unless @item
      head :not_found
      return
    else
      @item.destroy 
      # if cart is empty, reset session order_id to be nil 
      if @order.order_items == []
          session[:order_id] = nil
          flash[:status] = :success
          flash[:message] = "Your cart is empty"
          redirect_to products_path
          return 
      end 
      if @order.save
        flash[:status] = :success
        flash[:message] = "Item successfully deleted from cart"
      else
        flash[:status] = :error
        flash[:message] = "There was a problem deleting this item"
      end
      redirect_to view_cart_path
    end 
  end

  private

  def item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
    
end
