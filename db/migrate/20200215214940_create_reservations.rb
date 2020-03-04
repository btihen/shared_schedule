class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.string     :host
      t.date       :date,      null: false
      t.belongs_to :event,     null: false, foreign_key: true
      t.belongs_to :space,     null: false, foreign_key: true
      t.belongs_to :time_slot, null: false, foreign_key: true

      t.timestamps
    end
    add_index :reservations,  :date
    add_index :reservations, [:date, :event_id, :space_id, :time_slot_id], 
                                          unique: true, name: "index_reservation_unique"
  end
end
