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
    ## use this to replace CIP keywords with OE terms
    #keywords.collect! { |key| mappings.has_key?(key) ? mappings[key] : key } unless keywords.blank?

    ## use this to add OE terms to the existing CIP list
    mappings.each do |k,v|
      if keywords.include?(k)
        service.keywords << v
        service.keywords = service.keywords.uniq
      end
    end
    service.save
  end
end