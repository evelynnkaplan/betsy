require "test_helper"
require 'pry'

def create
  @order = current_order
  @item = @order.order_items.new(item_params)
  @order.save
  session[:order_id] = @order.id
  redirect_to products_path
end

describe OrderItemsController do
  before do
    @product = Product.first

    @order_item_data = {
      order_item: {
        product_id: @product.id,
        quantity: 1,
      },
    }

  end

  describe "guest user" do
    describe "create" do
      it "adds order item to cart and creates new order" do

        expect {
          post order_items_path, params: @order_item_data
        }.must_change "OrderItem.count", +1, "Order.count", +1

        order_item = OrderItem.last
        order = order_item.order

        check_flash

        # Assert 

        expect(order_item.product_id).must_equal @order_item_data[:order_item][:product_id]
        expect(order_item.quantity).must_equal @order_item_data[:order_item][:quantity]
        expect(session[:order_id]).must_equal order.id
        expect(order.order_items).must_include order_item
        expect(order.status).must_equal "pending"

        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "adds item to existing order" do
        expect {
          post order_items_path, params: @order_item_data 
        }.must_change "OrderItem.count", +1

        expect {
          post order_items_path, params: @order_item_data 
        }.wont_change "Order.count"

        order_item = OrderItem.last
        order = Order.last

        # binding.pry 

        check_flash

        # Assert - Test in progres 
        # expect(order.order_items.count).must_equal 3
        expect(order_item.product_id).must_equal @order_item_data[:order_item][:product_id]
        expect(order_item.quantity).must_equal @order_item_data[:order_item][:quantity]
        expect(session[:order_id]).must_equal order.id
        expect(order.order_items).must_include order_item
        expect(order.status).must_equal "pending"

        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "fails to create order for nonexistent order" do
      end
    end
  end

  describe "merchant" do
  end
end
