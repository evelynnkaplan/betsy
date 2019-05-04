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

        check_flash(expected_status = :error)

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
        must_redirect_to root_path
      end
    end 
  end

  describe "auth_callback" do
    it "logs in an existing merchant and redirects to root route" do
      expect {
        perform_login(@merchant)
      }.wont_change "Merchant.count"

      expect(session[:merchant_id]).must_equal @merchant.id
      must_redirect_to root_path
    end

    it "creates an account for a new merchant and redirects to the root route" do
      Merchant.destroy_all
      start_count = Merchant.count
      new_merchant = Merchant.new(provider: "github", uid: 99999, username: "random_user", email: "test@user.com")

      perform_login(new_merchant)

      must_redirect_to root_path

      Merchant.count.must_equal start_count + 1

      session[:merchant_id].must_equal Merchant.last.id
    end

    it "redirects to the login route if given invalid merchant data" do
      Merchant.destroy_all
      start_count = Merchant.count
      new_merchant = Merchant.new(provider: "github", uid: 99999, username: "", email: "test@user.com")

      perform_login(new_merchant)

      must_redirect_to github_login_path

      check_flash(:error)
      Merchant.count.must_equal start_count
    end
  end
end
