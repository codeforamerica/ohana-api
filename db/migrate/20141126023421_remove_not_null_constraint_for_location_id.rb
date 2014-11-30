class RemoveNotNullConstraintForLocationId < ActiveRecord::Migration
  def change
    change_column_null :contacts, :location_id, true
    change_column_null :phones, :location_id, true
  end
end
