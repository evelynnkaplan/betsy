require "pry"

class OrderItemsController < ApplicationController
  def add_product(product)
    if cart_product = self.cart_products.find_by_product_id(product.id)
      cart_product.quantity += 1
      cart_product.save
      cart_product
    else
      self.cart_products.create(:product_id => product.id, :quantity => 1)
    end
  end
  
  
  def create
    # an order is made, but not yet saved 
    @order = current_order

    # checks whether order item already exists in cart 
    @item = @order.order_items.find_by(product_id: item_params[:product_id])
    
    # updates quantity if orderitem already exists, otherwise creates new order item 
    if @item
      @item.quantity += item_params[:quantity].to_i 
    else 
      @item = @order.order_items.new(item_params)
    end 
    
    # save the order with the new item. each time an order item gets added, the order will be saved 
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
