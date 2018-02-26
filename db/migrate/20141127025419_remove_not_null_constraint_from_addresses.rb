class RemoveNotNullConstraintFromAddresses < ActiveRecord::Migration
  def change
    change_column_null :addresses, :street, true
    change_column_null :addresses, :city, true
    change_column_null :addresses, :state, true
    change_column_null :addresses, :zip, true
  end
end
