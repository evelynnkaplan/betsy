class RemoveKeyFromMerchants < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :merchants, column: :order_id
  end
end
