

class OrdersController < ApplicationController
  def index # a merchant can see their orders
    if session[:merchant_id]
      @merchant = Merchant.find_by(id: session[:merchant_id])
      @orders = @merchant.orders
    else
      flash[:status] = :error
      flash[:message] = "You don't have permission to see a list of orders. Please log in."
      redirect_to root_path
    end
  end

  def show # see the cart
    @order = Order.find_by(id: params[:id])

    if !session[:merchant_id]
      flash[:status] = :error
      flash[:message] = "You don't have permission to see this order. Please log in."
      redirect_to root_path
    elsif !@order
      flash[:status] = :error
      flash[:message] = "There is no order to view. Add an item to your shopping cart to start an order."
      redirect_to products_path
    elsif @order && (!@order.merchants || !@order.merchants.include?(Merchant.find_by(id: session[:merchant_id])))
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
    # This is the action for checking out.
    @order = Order.find_by(id: session[:order_id])
    @total_price = @order.total_price

    if !@order
      flash[:status] = :error
      flash[:message] = "You don't currently have an order. Add a secret to your cart to start an order."
      redirect_to products_path
    end
  end

  def update
    # This is the action that completes an order.
    @order = Order.find_by(id: session[:order_id])

    if !@order
      flash[:status] = :error
      flash[:message] = "You don't currently have an order. Add a secret to your cart to start an order."
      redirect_to products_path
    else
      @order.update(order_params)
      if in_stock?(@order.order_items)
        update_product_inventory
        @order.status = "paid"
      end
     
     if @order.save
        redirect_to order_confirmation_path
     else
        render :edit, status: :bad_request
     end
    end
  end

  def confirmation
    @order = Order.find_by(id: session[:order_id])

    if !@order || (@order.status == nil || @order.status == "pending")
      flash[:status] = :error
      flash[:message] = "There is no completed order to view."
      redirect_to products_path
    else
      session[:order_id] = nil
    end
  end

  def view_cart 
    @order_items = current_order.order_items
  end

  private

  def in_stock?(order_items)
    order_items.each { |item| return false if item.product.stock < item.quantity }

    return true
  end

  def update_product_inventory
    @order.order_items.each do |item|
      item.product.stock -=  item.quantity
      item.product.save
    end
  end

  def order_params
    return params.require(:order).permit(:email, :address, :mailing_zip, :name_on_card, :credit_card, :card_exp, :cvv, :billing_zip)
  end
end
