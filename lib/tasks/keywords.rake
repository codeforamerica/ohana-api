require 'json'

task :keywords => :environment do
  puts "================================================="
  puts "Renaming CIP keywords to OpenEligibilty taxonomy"
  puts "================================================="

  file = "data/keywords.json"

  puts "Processing #{file}"
  mappings = JSON.parse(File.read(file))

  services = Service.all
  services.each do |service|
    keywords = service.keywords
    keywords.collect! { |key| mappings.has_key?(key) ? mappings[key] : key } unless keywords.blank?
    service.save
  end
end