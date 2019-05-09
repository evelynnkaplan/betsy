class ChangeColumnOrders < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :credit_card, :bigint
  end
end
