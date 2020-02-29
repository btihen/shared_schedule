class CreateTimeSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :time_slots do |t|
      t.string   :time_slot_name, null: false
      t.time     :begin_time,     null: false
      t.time     :end_time,       null: false
      t.belongs_to :tenant,       null: false, foreign_key: true

      t.timestamps
    end
    add_index :time_slots, :time_slot_name,                      unique: true
    add_index :time_slots, [:begin_time, :end_time, :tenant_id], unique: true
  end
end
