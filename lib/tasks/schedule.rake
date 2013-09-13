require 'json'

task :add_weekdays_to_schedules => :environment do
  puts "================================================="
  puts "Adding days to each service schedule"
  puts "================================================="

  services = Service.all
  services.each do |service|
    7.times { service.schedules.create() }
    service.schedules.each_with_index { |s, i| s.day = i }
    service.save
  end
end