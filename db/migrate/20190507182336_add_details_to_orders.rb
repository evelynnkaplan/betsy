class AddDetailsToOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :zipcode, :mailing_zip
    add_column :orders, :billing_zip, :integer
    add_column :orders, :name_on_card, :string
    add_column :orders, :cvv, :integer
  end
end
