class CreateTenantManagers < ActiveRecord::Migration[6.0]
  def change
    create_table :tenant_managers do |t|
      t.belongs_to :tenant, null: false, foreign_key: true
      t.belongs_to :manager, class_name: 'User'

      t.timestamps

      t.foreign_key :users, column: :manager_id, index: true
    end
  end
end
