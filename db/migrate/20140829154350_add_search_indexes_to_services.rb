class AddSearchIndexesToServices < ActiveRecord::Migration
  def up
    execute "create index services_service_areas on services using gin(to_tsvector('english', service_areas))"
  end

  def down
    execute "drop index services_service_areas"
  end
end
