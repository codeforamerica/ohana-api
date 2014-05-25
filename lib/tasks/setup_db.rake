require 'json'

task :setup_db => [
  :create_categories,
  :load_data
  ]

task :load_data => :environment do
  orgs = 'data/mongo/organizations.json'
  locs = 'data/mongo/locations.json'
  services = 'data/mongo/services.json'

  puts "===> Populating the #{Rails.env} DB with #{orgs}..."
  puts '===> Hang tight, this will take a few seconds...'

  File.open(orgs).each do |line|
    data_item = JSON.parse(line)
    Organization.create!(data_item)
  end
  puts "===> Done populating the DB with #{orgs}."

  puts "===> Populating the #{Rails.env} DB with #{locs}..."
  File.open(locs).each do |line|
    data_item = JSON.parse(line)
    Location.create!(data_item)
  end
  puts "===> Done populating the DB with #{locs}."

  puts "===> Populating the #{Rails.env} DB with #{services}..."
  File.open(services).each do |line|
    hash = JSON.parse(line)
    Service.create!(hash)
  end
  puts "===> Done populating the DB with #{services}."

  puts '===> Assigning categories to services...'
  File.open(services).each do |line|
    hash = JSON.parse(line)

    cat_ids = []
    if hash['category_ids'].present?
      hash['category_ids'].each do |oe_id|
        cat = Category.find_by_oe_id(oe_id)
        cat_ids.push(cat.id)
      end

      # Set the service's category_ids to this new array of ids
      s = Service.find_by_id(hash['id'])
      s.category_ids = cat_ids
      s.save
    end
  end
  puts '===> Done assigning categories to services.'

  puts '===> Updating importance for human services...'
  human_services = Location.where(kind: 'human_services')
  human_services.each { |loc| loc.update(importance: 2) }
  puts '===> Done updating importance for human services...'

  puts '===> Updating importance for SMC HSA...'
  hsa = Location.belongs_to_org('San Mateo County Human Services Agency').
    readonly(false)
  hsa.each { |loc| loc.update(importance: 3) }
  puts '===> Done updating importance for SMC HSA...'
end
