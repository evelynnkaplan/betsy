require "test_helper"

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
        item_to_purchase = make_order(products(:product_one))
        cart = item_to_purchase.order

        cart_data = {
          order: {
            email: "big_bird",
            name_on_card: "Big Bird",
            address: "123 Sesame St",
            mailing_zip: 98119,
            billing_zip: 98119,
            credit_card: 1234567891012355,
            card_exp: "11/2020",
            cvv: 130,
            status: "pending",
            total_price: 15000,
          },
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
            address: "123 Sesame St",
            mailing_zip: 98119,
            billing_zip: 98119,
            credit_card: 1234567891012355,
            card_exp: Time.now,
            cvv: 130,
            status: "pending",
            total_price: 15000,
          },
        }
        # Act
        patch order_path(cart.id), params: cart_data
        cart.reload
        expect(cart.status).must_equal "paid"
      end

      it "sets the order status to 'hidden' if the remainder of a product's stock is bought" do
        oi = make_big_quantity_order
        cart = oi.order

        cart_data = {
          order: {
            email: "big_bird",
            name_on_card: "Big Bird",
            address: "123 Sesame St",
            mailing_zip: 98119,
            billing_zip: 98119,
            credit_card: 1234567891012355,
            card_exp: Time.now,
            cvv: 130,
            status: "pending",
            total_price: 15000,
          },
        }

        patch order_path(cart.id), params: cart_data
        cart.reload

        expect(oi.product.stock).must_equal 0
      end
    end

    describe "edit" do
      it "can get the checkout page for the current order" do
        make_order

        get checkout_path

        must_respond_with :ok
      end

      it "can't get the checkout page if there isn't an order id in session" do
        get checkout_path

        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "update" do
      it "successfully updates an order when given good data" do
        make_order
        test_order = Order.find(session[:order_id])
        order_params = {
          order: {
            email: "erica@noterica.com",
            address: "123 General Porpoise Ln",
            mailing_zip: 12345,
            name_on_card: "ELN",
            credit_card: 1234,
            card_exp: Date.new(2009, 01),
            cvv: 555,
            billing_zip: 12345,
          },
        }

        patch order_path(session[:order_id]), params: order_params

        test_order.reload

        expect(test_order.email).must_equal order_params[:order][:email]
      end

      it "redirects if there is no order id in the session" do
        test_order = Order.new

        order_params = {
          order_items: [order_items(:oi_one)],
        }

        test_order.update(order_params)
        test_order.save

        order_params = {
          order: {
            email: "erica@noterica.com",
            address: "123 General Porpoise Ln",
            mailing_zip: 12345,
            name_on_card: "ELN",
            credit_card: 1234,
            card_exp: Date.new(2009, 01),
            cvv: 555,
            billing_zip: 12345,
          },
        }

        patch order_path(test_order.id), params: order_params

        must_respond_with :redirect

        must_redirect_to products_path

        check_flash(:error)
      end
    end

    describe "confirmation" do
      it "can get the confirmation page if there's an order_id stored in session and then clears the session order id" do
        make_order
        test_order = Order.find_by(id: session[:order_id])
        test_order.status = "paid"
        order_params = {
          email: "erica@noterica.com",
          address: "123 General Porpoise Ln",
          mailing_zip: 12345,
          name_on_card: "ELN",
          credit_card: 1234,
          card_exp: Date.new(2009, 01),
          cvv: 555,
          billing_zip: 12345,
        }
        test_order.update(order_params)
        test_order.save
        test_order.reload

        get order_confirmation_path

        must_respond_with :ok
        expect(session[:order_id]).must_equal nil
      end

      it "redirects if there's no order id stored in session" do
        get order_confirmation_path

        must_respond_with :redirect
        must_redirect_to products_path
        check_flash(:error)
      end

      it "redirects if the order stored in session has a status of nil" do
        make_order
        test_order = Order.find_by(id: session[:order_id])
        test_order.status = nil
        test_order.save

        get order_confirmation_path

        must_respond_with :redirect
        must_redirect_to products_path
        check_flash(:error)
      end

      it "redirects if the order stored in session has a status of pending, the default" do
        make_order
        test_order = Order.find_by(id: session[:order_id])
        if test_order.status != "pending"
          test_order.status = "pending"
          test_order.save
        end

        get order_confirmation_path

        must_respond_with :redirect
        must_redirect_to products_path
        check_flash(:error)
      end
    end

    describe "view_cart" do
      it "can get the page if there's an order id stored in session" do
        make_order

        get view_cart_path
        must_respond_with :ok
      end

      it "can still get the page if there's not an order id stored in session" do
        get view_cart_path
        must_respond_with :ok
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
          address: "123 Sesame St",
          mailing_zip: 98119,
          billing_zip: 98119,
          credit_card: 1234567891012355,
          card_exp: Time.now,
          cvv: 130,
          total_price: 15000,
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
          order_items: [OrderItem.create!(order: test_order,
                                          product: Product.create!(merchant: Merchant.new(username: "hihi"),
                                                                   stock: 5, name: "test", price: 5), quantity: 1)],
          status: "paid",
          email: "big_bird",
          name_on_card: "Big Bird",
          address: "123 Sesame St",
          mailing_zip: 98119,
          billing_zip: 98119,
          credit_card: 1234567891012355,
          card_exp: Time.now,
          cvv: 130,
          total_price: 15000,
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
