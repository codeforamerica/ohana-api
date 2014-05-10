class AddSearchIndexesToLocations < ActiveRecord::Migration
  def up
    execute "create index locations_name on locations using gin(to_tsvector('english', name))"
    execute "create index locations_description on locations using gin(to_tsvector('english', description))"
    execute "create index locations_admin_emails on locations using gin(to_tsvector('english', admin_emails))"
    execute "create index locations_emails on locations using gin(to_tsvector('english', emails))"
    execute "create index locations_urls on locations using gin(to_tsvector('english', urls))"
    execute "create index locations_languages on locations using gin(to_tsvector('english', languages))"
  end

  def down
    execute "drop index locations_name"
    execute "drop index locations_description"
    execute "drop index locations_admin_emails"
    execute "drop index locations_emails"
    execute "drop index locations_urls"
    execute "drop index locations_languages"
  end
end
