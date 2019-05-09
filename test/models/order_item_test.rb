require "test_helper"

describe OrderItem do
  let(:order_item) { order_items{:oi_one} }

  describe "validations" do 
    it "can be instantiated" do 
      new_oi = OrderItem.new

      expect(new_oi.valid?).must_be true
    end
  end

  desribe "relationships" do 
    it "belongs to a merchant" do 

    end

    it "belongs to a product" do 
      
    end
  end


end
