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

        # binding.pry

        get order_path(test_order.id)

        must_respond_with :ok
      end
    end
  end
end
