class AddTenantToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :tenant, null: false, foreign_key: true
  end
end
