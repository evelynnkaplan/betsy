require "test_helper"

describe MerchantsController do
  describe "index" do
    it "can load without crashing" do
      get merchants_path

      must_respond_with :ok
    end
  end
end
