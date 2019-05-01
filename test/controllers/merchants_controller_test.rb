require "test_helper"

describe MerchantsController do
  before do
    @merchant = Merchant.first
  end

  describe "index" do
    it "can load without crashing" do
      get merchants_path

      must_respond_with :ok
    end
  end

  describe "edit" do
    it "responds with OK for logged in merchant" do
      # to revise when OAuth implemented
      session[:user_id] = 123
      get edit_merchant_path(@merchant)
      must_respond_with :ok
    end

    it "responds with NOT FOUND for a fake merchant" do
      session[:user_id] = 123
      merchant_id = -1
      get edit_merchant_path(merchant_id)
      must_respond_with :not_found
    end

    it "requests login for merchant not logged in" do
      get edit_merchant_path(@merchant)

      check_flash(expected_status = :error)
      must_respond_with :redirect
      # redirect to login page
    end
  end
end
