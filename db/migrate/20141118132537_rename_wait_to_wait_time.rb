class RenameWaitToWaitTime < ActiveRecord::Migration
  def change
    rename_column :services, :wait, :wait_time
  end
end
