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
    @item = @order.order_items.find(params[:id])
    @item.destroy
    @order.save
    redirect_to view_cart_path
  end

  private

  def item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
