class AddInvitedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :invited, :text
  end
end
