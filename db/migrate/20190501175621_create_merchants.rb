class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.integer :uid
      t.string :provider
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
