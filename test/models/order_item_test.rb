require "test_helper"

describe OrderItem do
  let(:order_item) { order_items(:oi_one) }

  describe "validations" do 
    it "can be instantiated with valid data" do 
      new_oi = OrderItem.new
      new_oi.quantity = 0
      new_oi.save
      
      expect(new_oi.valid?).must_equal false

      new_oi.update_attributes({ product: products(:product_one), 
                                order: orders(:cart_one),
                                quantity: 1
                              })
      
      expect(new_oi.valid?).must_equal true
    end
  end

  describe "relationships" do 
    describe "order" do 
      it "belongs to an order" do

        expect(order_item).must_respond_to :order
        expect(order_item.order).must_equal orders(:cart_one)
      end
    end

    describe "product" do 
      it "belongs to a product" do 
        expect(order_item).must_respond_to :product
      end
    end
  end

  describe "custom validation" do 
    describe "max quantity" do 
      it "will return true if stock is less than quantity requested" do 
        this_oi = OrderItem.create!(quantity: 5, product: products(:product_two), order: orders(:cart_one))
        inventory = products(:product_two).stock
        
        expect(this_oi.max_quantity).must_equal false
        expect(this_oi.quantity > inventory).must_equal true
      end
    end
  end


end
