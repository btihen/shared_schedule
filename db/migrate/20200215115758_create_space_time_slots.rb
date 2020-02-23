class CreateSpaceTimeSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :space_time_slots do |t|
      t.belongs_to :space,     null: false, foreign_key: true
      t.belongs_to :time_slot, null: false, foreign_key: true

      t.timestamps
    end
    add_index :space_time_slots, [:space_id, :time_slot_id], unique: true
  end
end
