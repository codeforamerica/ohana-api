task :test => :environment do
  system('rspec')
  system('rubocop --rails')
end
