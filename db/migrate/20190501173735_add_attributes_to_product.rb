class AddAttributesToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :description, :string
    add_column :products, :name, :string
    add_column :products, :price, :integer
    add_column :products, :stock, :integer
    add_column :products, :img_url, :string
  end
end
