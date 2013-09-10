require 'json'

task :load_farmers_markets => :environment do
  puts "===> Populating DB with San Mateo County Farmers' Markets..."

  file = "data/smc_farmers_markets.json"

  File.open(file).each do |line|
    data_item = JSON.parse(line)
    org = Organization.create!(data_item)

    locs = data_item["locs"]
    locs.each do |location|
      org.locations.create!(location)
    end

    org.locations.each { |loc| loc.update_attributes!(kind: :farmers_market) }
  end

  puts "===> Cleaning up the DB..."
  Organization.all.unset('locs')
end