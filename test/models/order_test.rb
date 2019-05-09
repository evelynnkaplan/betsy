require "test_helper"
require 'pry'
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

  end
  
  describe "custom methods" do 

  end
end
