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

    describe 'destroy' do 
      it "removes the order_item from the database" do
        order_item = OrderItem.first 

        # Act
        # expect {
          delete order_item_path(order_item)
        # }.must_change "OrderItem.count", -1

        # binding.pry 

        # Assert
        must_respond_with :redirect
        must_redirect_to view_cart_path

        check_flash

        after_order_item = OrderItem.find_by(id: order_item.id)
        expect(after_order_item).must_be_nil
      end

      it "returns a 404 if the order_item does not exist" do
        # Arrange
        order_item_id = -1

        # Assumptions
        expect(OrderItem.find_by(id: order_item_id)).must_be_nil

        # Act
        expect {
          delete order_item_path(order_item_id)
        }.wont_change "OrderItem.count"

        # Assert
        must_respond_with :not_found
      end
    end 
  end

  describe "merchant" do
  end
end
