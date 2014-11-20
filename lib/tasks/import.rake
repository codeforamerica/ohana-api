namespace :import do
  task all: [:organizations, :programs, :locations, :services, :mail_addresses,
             :contacts, :phones, :regular_schedules, :holiday_schedules]

  desc 'Imports organizations'
  task :organizations, [:path] => :environment do |_, args|
    Kernel.puts('Importing your organizations...')
    args.with_defaults(path: Rails.root.join('data/organizations.csv'))
    importer = OrganizationImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Imports programs'
  task :programs, [:path] => :environment do |_, args|
    Kernel.puts('Importing your programs...')
    args.with_defaults(path: Rails.root.join('data/programs.csv'))
    importer = ProgramImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Imports locations'
  task :locations, [:path, :addresses_path] => :environment do |_, args|
    Kernel.puts('Importing your locations and addresses...')
    args.with_defaults(
      path: Rails.root.join('data/locations.csv'),
      addresses_path: Rails.root.join('data/addresses.csv')
    )
    importer = LocationImporter.import_file(args[:path], args[:addresses_path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Imports services'
  task :services, [:path] => :environment do |_, args|
    Kernel.puts('Importing your services...')
    args.with_defaults(path: Rails.root.join('data/services.csv'))
    importer = ServiceImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Imports mail addresses'
  task :mail_addresses, [:path] => :environment do |_, args|
    Kernel.puts('Importing your mail addresses...')
    args.with_defaults(path: Rails.root.join('data/mail_addresses.csv'))
    importer = MailAddressImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Imports contacts'
  task :contacts, [:path] => :environment do |_, args|
    Kernel.puts('Importing your contacts...')
    args.with_defaults(path: Rails.root.join('data/contacts.csv'))
    importer = ContactImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Imports phones'
  task :phones, [:path] => :environment do |_, args|
    Kernel.puts('Importing your phones...')
    args.with_defaults(path: Rails.root.join('data/phones.csv'))
    importer = PhoneImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Imports regular_schedules'
  task :regular_schedules, [:path] => :environment do |_, args|
    Kernel.puts('Importing your regular_schedules...')
    args.with_defaults(path: Rails.root.join('data/regular_schedules.csv'))
    importer = RegularScheduleImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Imports holiday_schedules'
  task :holiday_schedules, [:path] => :environment do |_, args|
    Kernel.puts('Importing your holiday_schedules...')
    args.with_defaults(path: Rails.root.join('data/holiday_schedules.csv'))
    importer = HolidayScheduleImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end
end
