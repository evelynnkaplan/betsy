class ChangeCardExpToBeDateInOrders < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :card_exp, :date
  end
end
