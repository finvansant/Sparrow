class AddReplyToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :reply, :text
  end
end
