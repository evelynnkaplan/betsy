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
      merchant = perform_login
      
      get edit_merchant_path(merchant)
      must_respond_with :ok
    end

    it "rejects access to another merchant's dashboard" do
       merchant = merchants(:mickey)

       perform_login(merchant)
       another_merchant = merchants(:minnie)

       get edit_merchant_path(another_merchant)

       check_flash(expected_status = :error)

       must_redirect_to root_path 

    end 

    it "requests login for merchant not logged in" do
      get edit_merchant_path(@merchant)

      check_flash(expected_status = :error)
      must_respond_with :redirect
      # redirect to login page
    end
  end
end
