class AddUserInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name,  :string, null: false
    add_column :users, :user_title, :string
    add_column :users, :user_role,  :string, null: false, default: "member"
  end
end
