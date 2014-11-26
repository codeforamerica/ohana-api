class CopyServiceWaitToWaitTime < ActiveRecord::Migration
  def up
    execute "update services set wait_time = wait"
  end

  def down
    execute "update services set wait = wait_time"
  end
end
