class AddSearchIndexesToLocations < ActiveRecord::Migration
  def up
    execute "create index locations_admin_emails on locations using gin(to_tsvector('english', admin_emails))"
    execute "create index locations_emails on locations using gin(to_tsvector('english', emails))"
    execute "create index locations_urls on locations using gin(to_tsvector('english', urls))"
    execute "create index locations_languages on locations using gin(to_tsvector('english', languages))"
    execute "create index locations_kind on locations using gin(to_tsvector('english', kind))"
    execute "create index locations_payments on locations using gin(to_tsvector('english', payments))"
    execute "create index locations_products on locations using gin(to_tsvector('english', products))"
    add_index :locations, :market_match, name: 'locations_market_match_true', where: '(market_match IS TRUE)'
    add_index :locations, :market_match, name: 'locations_market_match_false', where: '(market_match IS FALSE)'
  end

  def down
    execute "drop index locations_admin_emails"
    execute "drop index locations_emails"
    execute "drop index locations_urls"
    execute "drop index locations_languages"
    execute "drop index locations_kind"
    execute "drop index locations_payments"
    execute "drop index locations_products"
    execute "drop index locations_market_match_true"
    execute "drop index locations_market_match_false"
  end
end
