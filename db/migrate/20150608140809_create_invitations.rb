class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :friend, index: true
      t.references :event, index: true

      t.timestamps null: false
    end
    add_foreign_key :invitations, :friends
    add_foreign_key :invitations, :events
  end
end
