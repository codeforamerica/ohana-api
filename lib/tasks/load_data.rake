require 'json'

task :load_data => :environment do
  puts "================================================================================"
  puts "Creating Organizations with Library and Farmers' Markets Data and saving to DB"
  puts "================================================================================"

  files = ['data/libraries_data.json', 'data/smc_farmers_markets.json']
  files.each do |file|
    puts "Processing #{file}"
    dataset = JSON.parse(File.read(file)).values
    dataset.each do |data_item|
      org = Organization.new(data_item)
      unless org.save
        invalid_records = {}
        invalid_filename_prefix = file.split('.json')[0].split('/')[1]
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
  puts "Done loading all files into DB."
end