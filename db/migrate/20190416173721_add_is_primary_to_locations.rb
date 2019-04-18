class AddIsPrimaryToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :is_primary, :boolean
  end
end
