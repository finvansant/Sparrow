class AddTotalsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :yes_total, :integer
    add_column :events, :no_total, :integer
  end
end
