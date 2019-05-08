class RemoveColumnMerchFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_index :orders, :merchant_id
    remove_index :merchants, :order_id
  end
end
