class AddWebsiteIndexToLocations < ActiveRecord::Migration
  def up
    execute "CREATE INDEX locations_website_with_varchar_pattern_ops ON locations (website varchar_pattern_ops);"
  end

  def down
    execute "DROP INDEX locations_website_with_varchar_pattern_ops"
  end
end
