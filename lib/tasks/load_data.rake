require 'json'

task :load_data => :environment do
  puts "========================================================================="
  puts "Creating Organizations with San Mateo County, CA Data and saving to DB"
  puts "========================================================================="

  file = "data/organizations.json"

  invalid_records = {}
  invalid_filename_prefix = file.split('.json')[0].split('/')[1]

  puts "Processing #{file}"
  dataset = JSON.parse(File.read(file))
  dataset.each do |data_item|
    org = Organization.new(data_item)
    unless org.save
      name = org["name"]
      invalid_records[name] = {}
      invalid_records[name]["errors"] = org.errors
      File.open("data/#{invalid_filename_prefix}_invalid_records.json","w") do |f|
        f.write(invalid_records.to_json)
      end
    end
  end
  puts "Done loading #{file} into DB"
  puts "Done loading San Mateo County data into DB."
end