require 'json'

task :keywords => :environment do
  puts "================================================="
  puts "Renaming CIP keywords to OpenEligibilty taxonomy"
  puts "================================================="

  file = "data/keywords.json"

  puts "Processing #{file}"
  mappings = JSON.parse(File.read(file))

  locs = Location.all
  locs.each do |loc|
    keywords = loc.keywords
    keywords.collect! { |key| mappings.has_key?(key) ? mappings[key] : key } unless keywords.blank?
    loc.save
  end
end