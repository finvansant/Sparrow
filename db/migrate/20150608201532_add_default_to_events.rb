class AddDefaultToEvents < ActiveRecord::Migration
  def change
    change_column :events, :yes_total, :integer, :default => 0
    change_column :events, :no_total, :integer, :default => 0
  end
end
