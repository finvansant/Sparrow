class AddGuestsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :guests, :text
  end
end
