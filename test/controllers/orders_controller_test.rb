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
      it "will reduce the product stock " do 
        # Arrange
        item_to_purchase = make_order
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
        patch order_path(cart.id), params: cart_data
        product_stock = item_to_purchase.product.stock
        
        expect(product_stock).must_equal 99

      end
      
      it "change the status from pending to paid" do
        item_to_purchase = make_order
        cart = item_to_purchase.order

        cart_data = {
            order: {
              email: "big_bird",
              name_on_card: "Big Bird",
              address:  "123 Sesame St",
              mailing_zip:  98119,
              billing_zip: 98119,
              credit_card: 1234567891012355,
              card_exp: Time.now,
              cvv: 130,
              status: "pending",
              total_price: 15000,
          }
        }
        # Act
        patch order_path(cart.id), params: cart_data
        cart.reload
        expect(cart.status).must_equal "paid"
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
          order_items: [OrderItem.create!(order: test_order, 
            product: Product.create!(merchant: Merchant.find_by(id: session[:merchant_id]), 
            stock: 5, name: "test", price: 5), quantity: 1)],
          status: "paid",
          email: "big_bird",
          name_on_card: "Big Bird",
          address:  "123 Sesame St",
          mailing_zip:  98119,
          billing_zip: 98119,
          credit_card: 1234567891012355,
          card_exp: Time.now,
          cvv: 130,
          total_price: 15000,
        }

        test_order.update(order_params)
        test_order.save

        # binding.pry 
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
          order_items: [OrderItem.create!(order: test_order, 
            product: Product.create!(merchant: Merchant.new(username: "hihi"), 
            stock: 5, name: "test", price: 5), quantity: 1)],
          status: "paid",
          email: "big_bird",
          name_on_card: "Big Bird",
          address:  "123 Sesame St",
          mailing_zip:  98119,
          billing_zip: 98119,
          credit_card: 1234567891012355,
          card_exp: Time.now,
          cvv: 130,
          total_price: 15000,
        }

        test_order.update(order_params)
        test_order.save
        # binding.pry
        test_order.reload

        get order_path(test_order.id)

        must_respond_with :redirect
        must_redirect_to dashboard_path
      end

      it "redirects if the logged-in merchant has a product in the order but the order status is pending" do
        test_order = Order.new

        order_params = {
          order_items: [OrderItem.create!(order: test_order, product: Product.create!(merchant: Merchant.find_by(id: session[:merchant_id]), stock: 5, name: "test", price: 5), quantity: 1)],
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
