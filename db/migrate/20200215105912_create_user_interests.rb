class CreateUserInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :user_interests do |t|
      t.belongs_to :category, null: false, foreign_key: true
      t.belongs_to :user,     null: false, foreign_key: true

      t.timestamps
    end
    add_index :user_interests, [:category_id, :user_id], unique: true
  end
end
