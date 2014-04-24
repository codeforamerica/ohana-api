class RemoveKindFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :kind, :text
  end
end
