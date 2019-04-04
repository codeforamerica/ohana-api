class RemoveDeletedAtColumnToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :deleted_at, :datetime
  end
end
