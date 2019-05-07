class ChangeUsernameToEmailInOrder < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :user_name, :email
  end
end
