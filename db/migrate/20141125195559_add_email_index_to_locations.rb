class AddEmailIndexToLocations < ActiveRecord::Migration
  def up
    execute "CREATE INDEX locations_email_with_varchar_pattern_ops ON locations (email varchar_pattern_ops);"
  end

  def down
    execute "DROP INDEX locations_email_with_varchar_pattern_ops"
  end
end
