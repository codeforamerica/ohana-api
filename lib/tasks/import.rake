namespace :import do
  task :all => [:organizations, :locations]

  desc 'Imports organizations'
  task :organizations, [:path] => :environment do |t, args|
    Kernel.puts("Importing your organizations...")
    args.with_defaults(path: Rails.root.join('data/organizations.csv'))
    importer = OrganizationImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Imports locations'
  task :locations, [:path, :addresses_path] => :environment do |t, args|
    Kernel.puts("Importing your locations and addresses...")
    args.with_defaults(
      path: Rails.root.join('data/locations.csv'),
      addresses_path: Rails.root.join('data/addresses.csv')
    )
    importer = LocationImporter.import_file(args[:path], args[:addresses_path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end
end
