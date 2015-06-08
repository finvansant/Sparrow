class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :events, :guests, :responses    
  end
end
