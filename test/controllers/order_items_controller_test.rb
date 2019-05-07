require "test_helper"
require "pry"

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
        order_item_hash = {
          order_item: {
            product_id: Product.second.id,
            quantity: 1,
          },
        }

        expect {
        post order_items_path, params: order_item_hash
        }.must_change "Order.count", +1

        expect {
          post order_items_path, params: @order_item_data
        }.wont_change "Order.count"

        order_item = OrderItem.last
        order = Order.last

        check_flash

        # Assert 
        expect(order.order_items.count).must_equal 2
        expect(order_item.product_id).must_equal @order_item_data[:order_item][:product_id]
        expect(order_item.quantity).must_equal @order_item_data[:order_item][:quantity]
        expect(session[:order_id]).must_equal order.id
        expect(order.order_items).must_include order_item
        expect(order.status).must_equal "pending"

        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "sends back bad_request if no order item data is sent" do
        
        order_item_hash = {
          order_item: {
            product_id: "",
            quantity: "",
          },
        }
        expect(OrderItem.new(order_item_hash[:order_item])).wont_be :valid?

        # Act
        expect {
          post order_items_path, params: order_item_hash
        }.wont_change "Order.count", "OrderItem.count"

        # Assert
        must_respond_with :redirect 

        check_flash(:error)
      end

    end
  end

  describe "merchant" do
  end
end
