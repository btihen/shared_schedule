class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string   :category_name, null: false
      t.string   :category_description

      t.belongs_to :tenant,    null: false, foreign_key: true

      t.timestamps
    end
    add_index :categories, [:category_name, :tenant_id], unique: true
  end
end
