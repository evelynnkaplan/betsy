require "test_helper"

def create
  @order = current_order
  @item = @order.order_items.new(item_params)
  @order.save
  session[:order_id] = @order.id
  redirect_to products_path
end

describe OrderItemsController do
  describe "guest user" do
    describe "create" do
      it "adds order item to cart and creates new order" do
        # session id = order.id
        # order.count +1
        # order contains order item
        # redirects to product path 
        # status should be pending 


        # Arrange
        order_item = OrderItem.new(product_id:)

        # Act 
          expect {
            post order_items_path 
      }.must_change "Order.count" +1
        # Assert 
      end

      it 'adds item to existing order' do
      end 

      it "fails to create order for nonexistent order" do
      end
    end
  end

  describe "merchant" do
  end

end
