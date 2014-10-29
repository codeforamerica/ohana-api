class RemoveHoursFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :hours, :text
  end
end
