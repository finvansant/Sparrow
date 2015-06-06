class CreateEventGuests < ActiveRecord::Migration
  def change
    create_table :event_guests do |t|
      t.references :event, index: true
      t.references :friend, index: true
      t.text :reply

      t.timestamps null: false
    end
    add_foreign_key :event_guests, :events
    add_foreign_key :event_guests, :friends
  end
end
