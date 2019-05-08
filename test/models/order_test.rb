require "test_helper"

describe Order do
  let(:order) {orders(:cart_one)}
  describe "validations" do 
    it "can be instantiated" do 
      new_order = Order.new

      expect(new_order.valid?).must_equal true
    end

    it "knows its fields" do 
      order_attribute_array.each do |field|
        expect(order).must_respond_to field
      end
    end

    it "validates for multiple required fields" do 
      new_order = Order.new
      new_order.save

      expect(new_order.errors.messages).must_include :name_on_card
      expect(new_order.errors.messages).must_include :credit_card
      expect(new_order.errors.messages).must_include :cvv
      expect(new_order.errors.messages).must_include :billing_zip
      expect(new_order.errors.messages).must_include :card_exp
      expect(new_order.errors.messages).must_include :status
    end
  end

  describe "relationships" do 

  end
  
  describe "custom methods" do 

  end
end
