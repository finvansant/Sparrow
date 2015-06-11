class AddPositionToFriends < ActiveRecord::Migration
  def change
    add_column :friends, :position, :integer
  end
end
