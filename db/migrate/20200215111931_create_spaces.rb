class CreateSpaces < ActiveRecord::Migration[6.0]
  def change
    create_table :spaces do |t|
      t.string :space_name, null: false
      t.string :space_location
      t.string :time_zone,  null: false, default: "Europe/Zurich"
      t.belongs_to :tenant, null: false, foreign_key: true

      t.timestamps
    end
    add_index :spaces,  :space_name
    add_index :spaces, [:space_name, :tenant_id], unique: true
  end
end
