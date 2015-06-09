class RemoveInvitedFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :invited, :text
  end
end
