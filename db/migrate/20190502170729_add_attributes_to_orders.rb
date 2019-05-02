class AddAttributesToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :user_name, :string
    add_column :orders, :address, :string
    add_column :orders, :zipcode, :integer
    add_column :orders, :credit_card, :integer
    add_column :orders, :card_exp, :date
    add_column :orders, :status, :string
  end
end
