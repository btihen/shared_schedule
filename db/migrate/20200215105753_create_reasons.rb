class CreateReasons < ActiveRecord::Migration[6.0]
  def change
    create_table :reasons do |t|
      t.string   :reason_description
      t.string   :reason_name, null: false

      t.belongs_to :tenant,    null: false, foreign_key: true

      t.timestamps
    end
    add_index :reasons, [:reason_description, :tenant_id], unique: true
  end
end
