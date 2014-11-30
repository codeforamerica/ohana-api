class RemoveNotNullConstraintFromContacts < ActiveRecord::Migration
  def change
    change_column_null :contacts, :title, true
  end
end
