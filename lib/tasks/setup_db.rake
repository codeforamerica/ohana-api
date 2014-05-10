require 'json'

task :setup_db => [
  :load_data,
  :create_categories]

task :load_data => :environment do
  file = "data/sample_data.json"

  puts "===> Populating the #{Rails.env} DB with #{file}..."
  puts "===> Hang tight, this will take a few seconds..."

  File.open(file).each do |line|
    data_item = JSON.parse(line)
    org = Organization.create!(data_item.except("locations"))

    locs = data_item["locations"]
    locs.each do |location|
      Location.create!(location.merge(organization_id: org.id))
    end
  end
  puts "===> Done populating the DB with #{file}."
end