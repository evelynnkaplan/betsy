require "test_helper"

describe Order do
  describe "validations" do 
    it "can be instantiated" do 
      new_order = Order.new

      expect(new_order.valid?).must_equal true
    end

    it "knows its fields" do 
      
    end
  end

  describe "relationships" do 

  end
  
  describe "custom methods" do 

  end
end
