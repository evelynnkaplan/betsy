class RemoveMerchIdFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :merchant_id
    remove_column :merchants, :order_id
  end
end
