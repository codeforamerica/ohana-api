collection :@locations
attributes :id, :accessibility, :admin_emails, :description,
           :emails, :hours, :kind, :languages, :latitude, :longitude,
           :market_match, :name, :payments, :products, :short_desc, :slug,
           :transportation, :urls, :url, :address, :contacts,
           :faxes, :mail_address, :phones, :services, :organization

node(:accessibility) { |loc| loc.accessibility.map(&:text) }

node(:kind) { |loc| loc.kind.text }

node(:payments, if: ->(loc) { loc.kind == 'farmers_markets' }) do |loc|
  loc.payments
end

node(:products, if: ->(loc) { loc.kind == 'farmers_markets' }) do |loc|
  loc.products
end

node(:market_match, if: ->(loc) { loc.kind == 'farmers_markets' }) do |loc|
  loc.market_match
end

node(:url) { |loc| api_location_url(loc) }
