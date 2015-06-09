class RemoveResponsesFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :responses, :text
  end
end
