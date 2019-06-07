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
      expect(merchant.products).must_equal [products(:product_one), products(:product_two),  products(:product_five)]
    end
  end

  describe "custom methods" do
    describe "order" do 
      it "gets the orders associated with a specific merchant" do
        oi_test = order_items(:oi_three)
        order = orders(:cart_three)
        order.order_items << oi_test

        expect(@merchant.orders).must_include order
      end

      it "will return nil if no order has that merchant's products" do 
        merchant = merchants(:merch_one)

        expect(@merchant.orders.first).must_be_nil
      end
    end

    describe "sold order items" do 
      it "needs a test" do 
        sold_orders = 0
        order_id = 0
        merchy = merchants(:merch_one)
          merchy.orders.each do |order|
           sold_orders = order.order_items.count
           order_id = order.id
          end
          
        expect(merchy.sold_order_items[order_id].count).must_equal sold_orders
      end
    end

    describe "total revenue" do 
      it "returns the total of all order item price sold by merchant" do
        merchy = merchants(:merch_one)
        revenue = 0
        merchant_products =  merchy.products
        merchant_products.each do |product|
          product.order_items.each do |order_item|
            product = Product.find_by(id: order_item.product_id)
            revenue += (product.price * order_item.quantity)
          end
        end
        

        expect(merchy.total_revenue).must_be_kind_of Integer
        expect(merchy.total_revenue).must_equal revenue
      end 
    end
  end
end
