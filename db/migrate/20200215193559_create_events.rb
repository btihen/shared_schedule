class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :event_name, null: false
      t.string :event_description

      t.belongs_to :category, null: false, foreign_key: true
      t.belongs_to :tenant,   null: false, foreign_key: true

      t.timestamps
    end
  end
end
