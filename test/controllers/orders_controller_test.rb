require "test_helper"
require "pry"

describe OrdersController do
  describe "all users" do
    describe "index" do
      it "will redirect when a user tries to get the page and isn't logged in" do
        get orders_path

        must_respond_with :redirect
        must_redirect_to root_path
        check_flash(:error)
      end
    end

    describe "show" do
      it "redirects if there's no logged in user" do
        get order_path(1)

        must_respond_with :redirect
        must_redirect_to root_path
        check_flash(:error)
      end
    end

    describe "update" do 
      it "will update a complete order and change status to 'paid'" do 
        # Arrange
        item_to_purchase = order_items(:oi_one)
        product_stock = item_to_purchase.product.stock
        cart = item_to_purchase.order

        cart_data = {
            order: {
            email: "big_bird",
            name_on_card: "Big Bird",
            address:  "123 Sesame St",
            mailing_zip:  98119,
            billing_zip: 98119,
            credit_card: 1234567891012355,
            card_exp: "11/2020",
            cvv: 130,
            status: "pending",
            total_price: 15000,
          }
        }
        # Act
        expect {
        post orders_path, params: cart_data
        }.must_change product_stock, -1

      end
      it "will reduce the inventory on a product when purchased" do
       
      end
    end

  end

  describe "logged-in merchants" do
    before do
      @merchant = perform_login
    end

    describe "index" do
      it "can get the orders page if there is a merchant logged in" do
        get orders_path

        must_respond_with :ok
      end
    end

    describe "show" do
      it "successfully loads the page of a paid order that exists and belongs to the logged-in merchant" do
        test_order = Order.new

        order_params = {
          order_items: [OrderItem.create!(order: test_order, product: Product.create!(merchant: Merchant.find_by(id: session[:merchant_id]), name: "test", price: 5), quantity: 1)],
          status: "paid",
        }

        test_order.update(order_params)
        test_order.save
        test_order.reload

        get order_path(test_order.id)

        must_respond_with :ok
      end

      it "redirects if a given a bad order ID" do
        get order_path(-2222)

        must_respond_with :redirect
        must_redirect_to products_path
        check_flash(:error)
      end

      it "redirects if the logged-in merchant does not have a product in the order" do
        test_order = Order.new

        order_params = {
          order_items: [OrderItem.create!(order: test_order, product: Product.create!(merchant: Merchant.create!(username: "test", email: "test.test"), name: "test", price: 5), quantity: 1)],
          status: "paid",
        }

        test_order.update(order_params)
        test_order.save
        test_order.reload

        get order_path(test_order.id)

        must_respond_with :redirect
        must_redirect_to dashboard_path
      end

      it "redirects if the logged-in merchant has a product in the order but the order status is pending" do
        test_order = Order.new

        order_params = {
          order_items: [OrderItem.create!(order: test_order, product: Product.create!(merchant: Merchant.find_by(id: session[:merchant_id]), name: "test", price: 5), quantity: 1)],
        }

        test_order.update(order_params)
        test_order.save
        test_order.reload

        get order_path(test_order.id)

        must_respond_with :redirect
        must_redirect_to view_cart_path
        check_flash(:error)
      end
    end
  end
end
