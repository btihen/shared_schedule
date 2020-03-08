class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.string     :host
      t.date       :end_date,         null: false
      t.date       :start_date,       null: false
      t.belongs_to :event,            null: false, foreign_key: true
      t.belongs_to :space,            null: false, foreign_key: true
      t.belongs_to :end_time_slot,    class_name: 'TimeSlot', null: false
      t.belongs_to :start_time_slot,  class_name: 'TimeSlot', null: false

      t.foreign_key :time_slots,      column: :end_time_slot_id,    index: true
      t.foreign_key :time_slots,      column: :start_time_slot_id,  index: true

      t.timestamps
    end
    add_index :reservations,  :end_date
    add_index :reservations,  :start_date
    add_index :reservations, [:event_id, :space_id,
                              :start_date, :start_time_slot_id,
                              :end_date, :end_time_slot_id],
                unique: true, name: "index_reservation_unique"
  end
end
