module ApplicationHelper
    def order_item_quantity
        return 0 unless current_order.order_items.count 
        return current_order.order_items.count
    end 
end
