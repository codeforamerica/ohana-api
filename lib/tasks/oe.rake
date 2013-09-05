require 'json'

task :create_categories => :environment do
  puts "======================================================="
  puts "Creating categories based on OpenEligibility Taxonomy"
  puts "======================================================="

  json = JSON.parse(File.read("data/oe.json"))

  top_levels = json["taxonomy"]["top_level"]

  top_levels.each do |hash|
    top_level = Category.create!(:name => hash["@title"], :oe_id => hash["@id"])
    top_level.save
    second_levels = hash["second_level"]
    second_levels.each do |h|
      second_level = top_level.children.create!(:name => h["@title"], :oe_id => h["@id"])
      second_level.save
      unless h["third_level"].nil?
        h["third_level"].each do |i|
          third_level = second_level.children.create!(:name => i["@title"], :oe_id => i["@id"])
          third_level.save
          unless i["fourth_level"].nil?
            i["fourth_level"].each do |j|
              third_level.children.create(:name => j["@title"], :oe_id => j["@id"])
            end
          end
        end
      end
    end
  end
end
