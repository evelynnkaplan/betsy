require "test_helper"

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
    # quantity less than 0
    # less than available stock
    # product is retired
    describe "create" do
      it "adds order item to cart and creates new order" do
        expect { make_order }.must_change "Order.count", +1, "OrderItem.count", +1

        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "updates quantity for duplicate item" do
        expect { make_order }.must_change "Order.count", +1, "OrderItem.count", +1
        expect { make_order }.wont_change "Order.count"

        must_respond_with :redirect
        must_redirect_to products_path
        order = Order.last
        expect(order.order_items.count).must_equal 1
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

    describe "destroy" do
      it "removes the order_item from the database" do
        make_order(Product.first)
        order_item = make_order(Product.second)

        # Act
        expect {
          delete order_item_path(order_item)
        }.must_change "OrderItem.count", -1

        # Assert
        must_respond_with :redirect
        must_redirect_to view_cart_path

        check_flash

        after_order_item = OrderItem.find_by(id: order_item.id)
        expect(after_order_item).must_be_nil
      end

      it "removes the only item in the order" do
        order_item = make_order
        order = order_item.order

        # Act
        expect {
          delete order_item_path(order_item)
        }.must_change "OrderItem.count", -1

        # Assert
        must_respond_with :redirect
        must_redirect_to products_path

        check_flash

        # order in session should be cleared
        after_order_item = OrderItem.find_by(id: order_item.id)
        expect(after_order_item).must_be_nil
        expect(session[:order_id]).must_be_nil
      end

      it "doesn't remove item in another cart" do
        order_item = OrderItem.first

        expect {
          delete order_item_path(order_item)
        }.wont_change "OrderItem.count"

        must_respond_with :not_found
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

    # need to add validations for stock
    describe "update" do
      before do
        @update_order_item = {
          order_item: {
            quantity: 4,
          },
        }

        @order_item = make_order
      end

      it "successfully updates quantity" do
        @order_item.assign_attributes(@update_order_item[:order_item])
        expect(@order_item).must_be :valid?
        @order_item.reload

        # Act
        patch order_item_path(@order_item), params: @update_order_item

        # Assert
        must_respond_with :redirect
        must_redirect_to view_cart_path

        check_flash

        @order_item.reload
        expect(@order_item.quantity).must_equal(@update_order_item[:order_item][:quantity])
      end

      it "rejects updating product_id" do
        item_quantity = @order_item.quantity
        product = Product.last
        update_order_item = {
          order_item: {
            product_id: product.id,
          },
        }

        patch order_item_path(@order_item), params: update_order_item

        must_respond_with :redirect
        must_redirect_to view_cart_path

        check_flash(:error)

        @order_item.reload

        expect(@order_item.product_id).wont_equal (update_order_item[:order_item][:product_id])
        expect(@order_item.quantity).must_equal item_quantity
      end

      it "updates quantity for item not in cart" do
      end

      it "redirects back if the order_item does not exist" do
        order_item_id = -1
        expect(OrderItem.find_by(id: order_item_id)).must_be_nil
        patch order_item_path(order_item_id), params: @update_order_item
        check_flash(:error)
        must_respond_with :redirect
        must_redirect_to view_cart_path
      end
    end
  end

  describe "merchant" do
  end
end
