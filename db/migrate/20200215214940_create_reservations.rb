class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.string     :host
      t.text       :change_note
      t.datetime   :start_date_time,  null: false
      t.date       :start_date,       null: false
      t.date       :end_date,         null: false
      t.boolean    :is_cancelled,     null: false, default: false
      t.belongs_to :event,            null: false, foreign_key: true
      t.belongs_to :space,            null: false, foreign_key: true
      t.belongs_to :tenant,           null: false, foreign_key: true
      t.belongs_to :start_time_slot,  null: false, class_name: 'TimeSlot'
      t.belongs_to :end_time_slot,    null: false, class_name: 'TimeSlot'

      t.foreign_key :time_slots,      column: :start_time_slot_id,  index: true
      t.foreign_key :time_slots,      column: :end_time_slot_id,    index: true

      t.timestamps
    end
    add_index :reservations,  :end_date
    add_index :reservations,  :start_date
    add_index :reservations, [:event_id, :space_id, :start_date, :end_date,
                              :start_time_slot_id, :end_time_slot_id],
                            unique: true, name: "index_reservation_unique"
  end
end
