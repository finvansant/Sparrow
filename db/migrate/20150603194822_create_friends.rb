class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :name
      t.string :phone
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :friends, :users
  end
end
