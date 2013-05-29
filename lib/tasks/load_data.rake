require 'json'

task :load_data => :environment do
  puts "===================================================="
  puts "Creating Organizations with Library and Farmers' Markets Data and saving to DB"
  puts "===================================================="

  files = ['data/libraries_data.json', 'data/smc_farmers_markets.json']
  files.each do |file|
    puts "Processing #{file}"
    data = JSON.parse(File.read(file)).values
    data.each do |json|
      Organization.create! do |db|
        json.keys.each do |field|
          db[field] = json[field.to_s]
        end
      end
    end
    puts "Done loading #{file} into DB"
  end
  puts "Done loading all files into DB."
end