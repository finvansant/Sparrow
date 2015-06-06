class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true
      t.text :body
      t.integer :yes_tot
      t.integer :no_tot
      t.boolean :active

      t.timestamps null: false
    end
    add_foreign_key :events, :users
  end
end
