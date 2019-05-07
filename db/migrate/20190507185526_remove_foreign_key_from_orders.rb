class RemoveForeignKeyFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :orders, column: :merchant_id
  end
end
