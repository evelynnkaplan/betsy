require "test_helper"

describe Order do
  let(:order) { orders(:cart_one) }

  describe "validations" do 
    it "can be instantiated only with an order item" do 
      order.order_items << order_items(:oi_one)
      # failing test...
      expect(order.valid?).must_equal true
    end

    it "knows its fields" do 
      order_attribute_array.each do |field|
        expect(order).must_respond_to field
      end
    end

    it "validates for multiple required fields" do 
      new_order = Order.new
      new_order.status = "paid"

      # expect(new_order.errors.messages).must_include :name_on_card
      # expect(new_order.errors.messages).must_include :credit_card
      # expect(new_order.errors.messages).must_include :cvv
      # expect(new_order.errors.messages).must_include :billing_zip
      # expect(new_order.errors.messages).must_include :card_exp
    end
  end

  describe "relationships" do
    it "is within a cart (order)" do 
      cart_items = OrderItem.where(order_id: order.id) 
      expect(order.order_items.count).must_equal cart_items.count
    end
  end
  
  describe "custom methods" do 

  end
end
