class AddActiveToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :active, :boolean, default: true
    add_index :locations, :active
  end
end
