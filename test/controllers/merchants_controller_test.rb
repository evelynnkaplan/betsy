require "test_helper"
require 'pry'

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

  describe "logged-in merchant" do
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

        # check_flash(expected_status = :error)

        must_redirect_to root_path
      end
    end

    describe "update" do
      let(:merchant_data) {
        {
          merchant: {
            email: "updatedemail@disney.com",
          },
        }
      }

      it "changes the data on the model" do
        perform_login(@merchant)

        @merchant.assign_attributes(merchant_data[:merchant])
        expect(@merchant).must_be :valid?
        @merchant.reload

        # binding.pry 

        patch merchant_path(@merchant), params: merchant_data
        @merchant.reload

        must_respond_with :redirect
        must_redirect_to merchant_path(@merchant)

        check_flash

        expect(@merchant.email).must_equal(merchant_data[:merchant][:email])
      end
    end
  end

  describe "guest users" do
    describe "edit" do
      it "requests login for merchant not logged in" do
        get edit_merchant_path(@merchant)

        check_flash(expected_status = :error)
        must_respond_with :redirect
        # redirect to login page
      end
    end
  end
end
