class RemoveNotNullConstraintFromMailAddresses < ActiveRecord::Migration
  def change
    change_column_null :mail_addresses, :street, true
    change_column_null :mail_addresses, :city, true
    change_column_null :mail_addresses, :state, true
    change_column_null :mail_addresses, :zip, true
  end
end
