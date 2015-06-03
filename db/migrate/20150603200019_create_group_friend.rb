class CreateGroupFriend < ActiveRecord::Migration
  def change
    create_table :group_friends do |t|
      t.references :group, index: true
      t.references :friend, index: true
      t.integer :position
    end
    add_foreign_key :group_friends, :groups
    add_foreign_key :group_friends, :friends
  end
end
