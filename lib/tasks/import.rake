namespace :import do
  task all: %i[organizations programs locations taxonomy services
               mail_addresses contacts phones regular_schedules
               holiday_schedules touch_locations]

  desc 'Imports organizations'
  task :organizations, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data/organizations.csv'))
    OrganizationImporter.check_and_import_file(args[:path])
  end

  desc 'Imports programs'
  task :programs, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data/programs.csv'))
    ProgramImporter.check_and_import_file(args[:path])
  end

  desc 'Imports locations'
  task :locations, %i[path addresses_path] => :environment do |_, args|
    Kernel.puts("\n===> Importing locations.csv and addresses.csv")
    args.with_defaults(
      path: Rails.root.join('data/locations.csv'),
      addresses_path: Rails.root.join('data/addresses.csv')
    )
    LocationImporter.check_and_import_file(args[:path], args[:addresses_path])
  end

  desc 'Imports taxonomy'
  task :taxonomy, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data/taxonomy.csv'))
    CategoryImporter.check_and_import_file(args[:path])
  end

  desc 'Imports services'
  task :services, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data/services.csv'))
    ServiceImporter.check_and_import_file(args[:path])
  end

  desc 'Imports mail addresses'
  task :mail_addresses, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data/mail_addresses.csv'))
    MailAddressImporter.check_and_import_file(args[:path])
  end

  desc 'Imports contacts'
  task :contacts, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data/contacts.csv'))
    ContactImporter.check_and_import_file(args[:path])
  end

  desc 'Imports phones'
  task :phones, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data/phones.csv'))
    PhoneImporter.check_and_import_file(args[:path])
  end

  desc 'Imports regular_schedules'
  task :regular_schedules, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data/regular_schedules.csv'))
    RegularScheduleImporter.check_and_import_file(args[:path])
  end

  desc 'Imports holiday_schedules'
  task :holiday_schedules, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data/holiday_schedules.csv'))
    HolidayScheduleImporter.check_and_import_file(args[:path])
  end

  # rubocop:disable Rails/SkipsModelValidations
  desc 'Touch locations'
  task :touch_locations, [:path] => :environment do
    Kernel.puts "\n===> Updating the full-text search index"
    Location.update_all(updated_at: Time.zone.now)
  end
  # rubocop:enable Rails/SkipsModelValidations
end
