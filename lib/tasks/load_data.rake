require 'json'

task :load_data => :environment do
  puts "========================================================================="
  puts "Creating Organizations with San Mateo County, CA Data and saving to DB"
  puts "========================================================================="

  file = "data/test.json"

  invalid_records = {}
  invalid_filename_prefix = file.split('.json')[0].split('/')[1]

  puts "Processing #{file}"
  File.open(file).each do |line|
    data_item = JSON.parse(line)
    data_item.reject! { |k,_| k == "created_at" || k == "updated_at" }
    org = Organization.create!(data_item)

    locs  = data_item["locs"]
    locs.each do |location|
      org.locations.create!(location)
      # the org needs to be saved again so that the _keywords
      # field gets updated for the mongoid_search gem to do its job
      org.save
    end

    db_locs = org.locations #the newly created locations

    # Use .zip to pair each location hash from the json file to the
    # newly-created location.
    # This results in: [ [db_loc1, json_loc1], [db_loc2, json_loc2] ]
    pairs = db_locs.zip(locs)
    pairs.each do |pair|
      if pair[1]["langs"].present?
        pair[1]["langs"].each do |lang|
        pair[0].languages.create(:name => lang)
        # pair[0].languages << lang
        # pair[0].save
        end
      end
    end
    Organization.all.unset('locs')
    Location.all.unset('langs')
  end
  puts "Done loading #{file} into DB"
  puts "Done loading San Mateo County data into DB."
end