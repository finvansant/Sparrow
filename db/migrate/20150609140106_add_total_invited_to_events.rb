class AddTotalInvitedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :total_invited, :integer, :default => 1
  end
end
