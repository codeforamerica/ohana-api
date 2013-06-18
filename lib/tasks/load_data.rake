require 'json'

task :load_data => :environment do
  puts "========================================================================="
  puts "Creating Organizations with San Mateo County, CA Data and saving to DB"
  puts "========================================================================="

  files = ['data/organizations.json']
  files.each do |file|
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
  end
  puts "Done loading San Mateo County data into DB."
end