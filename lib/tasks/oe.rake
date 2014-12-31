require 'json'

task create_categories: :environment do
  Kernel.puts 'Creating categories based on OpenEligibility Taxonomy...'

  json ||= JSON.parse(File.read('data/oe.json'))

  top_levels ||= json['taxonomy']['top_level']

  top_levels.each do |hash|
    top_level = Category.create!(name: hash['@title'], taxonomy_id: hash['@id'])
    hash['second_level'].each do |h|
      second_level = top_level.children.create!(name: h['@title'], taxonomy_id: h['@id'])
      next if h['third_level'].nil?
      h['third_level'].each do |i|
        third_level = second_level.children.create!(name: i['@title'], taxonomy_id: i['@id'])
        next if i['fourth_level'].nil?
        i['fourth_level'].each do |j|
          third_level.children.create(name: j['@title'], taxonomy_id: j['@id'])
        end
      end
    end
  end
end
