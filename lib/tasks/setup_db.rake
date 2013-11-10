require 'json'

task :setup_db => [
  :load_cip_data,
  :load_farmers_markets,
  :create_categories,
  :fix_faxes]

task :load_cip_data => :environment do
  puts "===> Populating the DB with San Mateo County, CA data."
  puts "===> Hang tight, this will take a few seconds..."

  file = "data/sample_data.json"

  File.open(file).each do |line|
    data_item = JSON.parse(line)
    org = Organization.create!(data_item)

    locs = data_item["locs"]
    locs.each do |location|
      org.locations.create!(location)
    end
    db_locs = org.locations # the newly created locations

    # Use .zip to pair each location hash from the json file to the
    # newly-created location.
    # This results in: [ [db_loc1, json_loc1], [db_loc2, json_loc2] ]
    pairs = db_locs.zip(locs)
    pairs.each do |pair|

      services = pair[1]["servs"]
      if services.present?
        services.each do |service|
          pair[0].services.create!(service)
        end
      end
    end
  end
  puts "===> Cleaning up the DB..."
  Organization.all.unset('locs')
  Location.all.unset('servs')
end