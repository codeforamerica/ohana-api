require 'json'

task :load_data => :environment do
  puts "========================================================================="
  puts "Creating Organizations with San Mateo County, CA Data and saving to DB"
  puts "========================================================================="

  file = "data/ohana_airs_8-26.json"

  puts "Processing #{file}"
  File.open(file).each do |line|
    data_item = JSON.parse(line)
    #data_item.reject! { |k,_| k == "created_at" || k == "updated_at" }
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
  puts "Done loading #{file} into DB"
  Organization.all.unset('locs')
  puts "Done unsetting locs from Organization"
  Location.all.unset('servs')
  puts "Done unsetting servs from Location"
end