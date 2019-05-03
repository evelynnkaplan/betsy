require "test_helper"

describe Merchant do
  before do
    @merchant = merchants(:mickey)
  end

  describe "instantiation" do
    it "can be instantiated" do
      expect(@merchant.valid?).must_equal true
    end

    it "has all attributes" do
      merchant_attribute_array.each do |field|
        expect(@merchant).must_respond_to field
      end
    end
  end

  describe "validations" do
    it "validates username is present" do
      @merchant.username = ""
      empty_username = @merchant.save

      expect(empty_username).must_equal false
      expect(@merchant.errors.messages).must_include :username
      @merchant.reload
    end

    it "validates username is unique" do
      used_username = @merchant.username
      new_merchant = Merchant.new(username: merchants(:merch_one).username)
      new_merchant.save

      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :username
    end

    it "validates email is present" do
      @merchant.email = ""
      empty_email = @merchant.save

      expect(empty_email).must_equal false
      expect(@merchant.errors.messages).must_include :email
      @merchant.reload
    end

    it "validates email is unique" do
      used_email = @merchant.email
      new_merchant = Merchant.new(email: merchants(:merch_one).email)
      new_merchant.save

      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :email
    end
  end

  describe "relationships" do
    it "has products" do
      merchant = merchants(:merch_one)
      expect(merchant).must_respond_to :products
      expect(merchant.products).must_equal [products(:product_one), products(:product_two)]
    end
  end
end
