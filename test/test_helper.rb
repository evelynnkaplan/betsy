require 'simplecov'
SimpleCov.start do 
  add_filter %r{^/specs?/}
end

require 'pry'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
#  For colorful output!

Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...

  def product_attribute_array
    return ["price", "stock", "merchant_id", "description", "img_url", "name"]
    # add products_categories after we create the join table...
  end

  def merchant_attribute_array
    return ["uid", "provider", "name", "email", "username"]
  end

  def order_attribute_array
    return %w(name_on_card email mailing_zip billing_zip cvv address credit_card card_exp status total_price)
  end

  def check_flash(expected_status = :success)
    if flash[:status]
      expect(flash[:status]).must_equal(expected_status)
      expect(flash[:message]).wont_be_nil
    else 
      expect(flash.keys).must_include(expected_status.to_s)
      expect(flash[expected_status]).wont_be_nil
    end 
  end

  def setup
    # Once you have enabled test mode, all requests
    # to OmniAuth will be short circuited to use the mock authentication hash.
    # A request to /auth/provider will redirect immediately to /auth/provider/callback.
    OmniAuth.config.test_mode = true
  end

  # def current_merchant
  #   current_merchant = Merchant.find(session[:merchant_id]) if session[:merchant_id]
  #   return current_merchant
  # end

  def perform_login(merchant = nil)
    merchant ||= Merchant.first

    # Create mock data for this merchant as though it had come from github
    mock_auth_hash = {
      uid: merchant.uid,
      provider: merchant.provider,
      info: {
        username: merchant.username,
        email: merchant.email,
      },
    }

    # Tell OmniAuth to use this data for the next request
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash)

    get auth_callback_path("github")

    return merchant
  end


  def make_order(product = nil)
    product ||= Product.first 
    order_item_data = {
      order_item: {
        product_id: product.id,
        quantity: 1,
      },
    }
    expect {
      post order_items_path, params: order_item_data
    }.must_change "OrderItem.count", +1, "Order.count", +1
 
    check_flash

    return OrderItem.last 
  end 
end
