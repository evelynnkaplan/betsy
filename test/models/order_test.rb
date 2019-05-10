require "test_helper"

describe Order do
  let(:order) {orders(:cart_one)}

  describe "validations" do 
    it "can be instantiated" do 
      order.order_items << order_items(:oi_one)
      order.save
     
      expect(order.valid?).must_equal true
      
    end

    it "knows its fields" do 
      order_attribute_array.each do |field|
        expect(order).must_respond_to field
      end
    end

    it "validates for multiple required fields" do 
      new_order = Order.new
      new_order.order_items << order_items(:oi_one)
      new_order.status = "paid"
      new_order.save

      expect(new_order.errors.messages).must_include :name_on_card
      expect(new_order.errors.messages).must_include :credit_card
      expect(new_order.errors.messages).must_include :cvv
      expect(new_order.errors.messages).must_include :billing_zip
      expect(new_order.errors.messages).must_include :card_exp
  
    end
  end

  describe "relationships" do 
    it "has many ties to order items and products" do 
      expect(order).must_respond_to :order_items
      expect(order).must_respond_to :products
    end

    it "must have at least one order item" do 
      another_order = orders(:cart_two)

      expect(another_order.valid?).must_equal false

      another_order.order_items << order_items(:oi_one)
      another_order.reload

      expect(another_order.valid?).must_equal true
    end
  end
  
  describe "custom methods" do 
    describe "merchants" do 
      it "can access the merchants associated with an order item in a cart"  do
        
        expect(order).must_respond_to :merchants 

      end

      it "will return an array of merchants" do
        merchant = order_items(:oi_one).product.merchant
        order.order_items << order_items(:oi_one)

        expect(order.merchants.first).must_equal merchant
        expect(order.merchants).must_be_kind_of Array
      end
    end
  end
end
