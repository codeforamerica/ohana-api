namespace :db do
  namespace :seed do
    task all: %i[dev]
    desc 'Data for development'
    task :dev, [:path] => :environment do |_, args|
      Kernel.puts 'Setting right sequence to Organization...'
      ActiveRecord::Base.connection.execute("select setval('organizations_id_seq', 26);")

      Kernel.puts 'Setting up 32 events for Organization...'
      Event.delete_all
      32.times do |index|
        date = Faker::Time.between(DateTime.now - index.hours, DateTime.now)
        Event.create!(
          title: Faker::Job.title,
          posted_at: date,
          starting_at: date,
          ending_at: DateTime.now + index.hours,
          city: Faker::Address.city,
          body: Faker::Lorem.paragraph,
          is_featured: %w[false true].sample,
          street_1: Faker::Address.street_address,
          street_2: Faker::Address.street_address,
          organization_id: 1,
          user_id: 3,
          state_abbr: Faker::Address.state_abbr,
          zip: Faker::Address.zip,
          phone: Faker::PhoneNumber.cell_phone,
          external_url: Faker::Internet.url
        )
      end

      Kernel.puts 'Setting up 3 events for another Organization...'
      3.times do |index|
        date = Faker::Time.between(DateTime.now - index.hours, DateTime.now)
        Event.create!(
          title: Faker::Job.title,
          posted_at: date,
          starting_at: date,
          ending_at: DateTime.now + index.hours,
          city: Faker::Address.city,
          body: Faker::Lorem.paragraph,
          is_featured: %w[false true].sample,
          street_1: Faker::Address.street_address,
          street_2: Faker::Address.street_address,
          organization_id: 2,
          user_id: 3,
          state_abbr: Faker::Address.state_abbr,
          zip: Faker::Address.zip,
          phone: Faker::PhoneNumber.cell_phone,
          external_url: Faker::Internet.url
        )
      end

      Kernel.puts 'Setting up BlogPost default Tags...'
      Tag.delete_all
      ['featured', 'front page'].each do |tag|
        next unless Tag.find_by_name(tag).blank?
        Tag.create!(
          name: tag
        )
      end

      Kernel.puts 'Setting up BlogPost...'
      BlogPost.delete_all
      32.times do |index|
        blog = BlogPost.new(
          title: Faker::Job.title,
          posted_at: Faker::Time.between(DateTime.now - index.hours, DateTime.now),
          is_published: %w[false true].sample,
          user_id: 3,
          body: Faker::Lorem.paragraph,
          blog_post_attachments_attributes: [
            {
              file_type: %w[video image audio].sample,
              file_url: Faker::Avatar.image,
              file_legend: Faker::Lorem.sentence,
              order: rand(1..3)
            }
          ],
          organization_id: 1
        )
        blog.category_list = ['featured', 'front page'].sample
        blog.save
      end

      Kernel.puts 'Setting right sequence to Locations...'
      last_location_id = ActiveRecord::Base.connection.execute('SELECT id FROM locations ORDER BY id DESC LIMIT 1;')
      last_location_id = last_location_id[0]['id'].to_i
      ActiveRecord::Base.connection.execute("select setval('locations_id_seq', #{last_location_id});")

      Kernel.puts 'Setting up Locations...'
      last_phone_id = ActiveRecord::Base.connection.execute('SELECT id FROM phones ORDER BY id DESC LIMIT 1;')
      last_phone_id = if last_phone_id.cmd_tuples > 0
                        last_phone_id[0]['id'].to_i
                      else
                        1
                      end
      ActiveRecord::Base.connection.execute("select setval('phones_id_seq', #{last_phone_id});")

      last_mail_address_id = ActiveRecord::Base.connection.execute('SELECT id FROM mail_addresses ORDER BY id DESC LIMIT 1;')
      last_mail_address_id = if last_mail_address_id.cmd_tuples > 0
                              last_mail_address_id[0]['id'].to_i
                             else
                              1
                             end
      ActiveRecord::Base.connection.execute("select setval('mail_addresses_id_seq', #{last_mail_address_id});")

      last_regular_schedule_id = ActiveRecord::Base.connection.execute('SELECT id FROM regular_schedules ORDER BY id DESC LIMIT 1;')
      last_regular_schedule_id = if last_regular_schedule_id.cmd_tuples > 0
                                  last_regular_schedule_id[0]['id'].to_i
                                 else
                                   1
                                 end
      ActiveRecord::Base.connection.execute("select setval('regular_schedules_id_seq', #{last_regular_schedule_id});")

      last_mail_holiday_schedule_id = ActiveRecord::Base.connection.execute('SELECT id FROM holiday_schedules ORDER BY id DESC LIMIT 1;')
      last_mail_holiday_schedule_id = if last_mail_holiday_schedule_id.cmd_tuples > 0
                                        last_mail_holiday_schedule_id[0]['id'].to_i
                                      else
                                        1
                                      end
      ActiveRecord::Base.connection.execute("select setval('holiday_schedules_id_seq', #{last_mail_holiday_schedule_id});")

      last_service_id = ActiveRecord::Base.connection.execute('SELECT MAX(id) as max FROM services;')
      last_service_id = if last_service_id.cmd_tuples > 0
                          last_service_id[0]['max'].to_i
                        else
                          1
                        end
      ActiveRecord::Base.connection.execute("select setval('services_id_seq', #{last_service_id});")

      last_friendly_id = ActiveRecord::Base.connection.execute('SELECT id FROM friendly_id_slugs ORDER BY id DESC LIMIT 1;')
      last_friendly_id = last_friendly_id[0]['id'].to_i
      ActiveRecord::Base.connection.execute("SELECT setval('friendly_id_slugs_id_seq', #{last_friendly_id + 1});")

      organization = Organization.find(1)
      organization.locations.delete_all
      Kernel.puts 'Setting up Location for Organization #1...'
      create_locations_for_organization(1)

      organization = Organization.find(2)
      organization.locations.delete_all
      2.times do
        Kernel.puts 'Setting up Location for Organization #2...'
        create_locations_for_organization(2)
      end

      organization = Organization.find(3)
      organization.locations.delete_all
      3.times do
        Kernel.puts 'Setting up Location for Organization #3...'
        create_locations_for_organization(3)
      end
    end
  end
end

def create_locations_for_organization(organization_id)
  Faker::Config.locale = 'en-US'
  location_name = Faker::Address.street_address
  organization = Organization.find(organization_id)
  organization.update(description: Faker::Lorem.paragraph(150))
  location = organization.locations.create!(
    accessibility: %w[cd deaf_interpreter disabled_parking elevator ramp restroom tape_braille tty wheelchair wheelchair_van].sample(3),
    active: true,
    admin_emails: [Admin.first.try(:email)],
    alternate_name: Faker::Job.title,
    description: Faker::Lorem.paragraph(150),
    email: Faker::Internet.email,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    name: location_name,
    short_desc: Faker::Lorem.paragraph,
    website: Faker::Internet.url,
    virtual: false,
    languages: %w[English Spanish Tagalog].sample(2),
    transportation: Faker::Address.community,
    organization_id: [1, 2, 3, 4, 5, 6, 10].sample,
    address_attributes: {
      address_1: location_name,
      city: Faker::Address.city,
      postal_code: Faker::Address.postcode,
      country: Faker::Address.country_code,
      state_province: Faker::Address.state_abbr
    },
    mail_address_attributes: {
      attention: Faker::Name.name,
      city: Faker::Address.city,
      state_province: Faker::Address.state_abbr,
      address_1: location_name,
      address_2: Faker::Address.street_address,
      postal_code: Faker::Address.postcode,
      country: Faker::Address.country_code
    },
    phones_attributes: [
      {
        country_prefix: Faker::PhoneNumber.country_code,
        department: 'Food Pantry',
        extension: Faker::PhoneNumber.extension,
        number: Faker::PhoneNumber.cell_phone,
        number_type: %w[voice hotline sms tty fax].sample,
        vanity_number: Faker::PhoneNumber.cell_phone
      }
    ],
    regular_schedules_attributes: [
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      },
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      },
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      },
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      },
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      }
    ],
    holiday_schedules_attributes: [
      {
        closed: %w[false true].sample,
        start_date: Faker::Date.between(1.month.ago, Date.today),
        end_date: Faker::Date.between(3.days.ago, Date.today),
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample,
      }
    ]
  )

  location.services.create!({
    description: Faker::Lorem.paragraph(100),
    fees: ['Fee Charged', 'Free'].sample,
    name: Faker::Job.title,
    status: 'active',
    website: Faker::Internet.url,
    accepted_payments: ['Cash', 'Check', 'Credit Card'].sample(2),
    languages: %w[English Spanish Tagalog].sample(2),
    required_documents: %w[Another This Test Lorem].sample(2),
    alternate_name: Faker::Job.title,
    email: Faker::Internet.email,
    audience: Faker::Lorem.paragraph(50),
    eligibility: Faker::Lorem.paragraph(50),
    funding_sources: ['Donations', 'Grants', 'DC Government'].sample(2),
    keywords: ['hot meels', 'hungry'].sample(2),
    service_areas: ['Alameda County', 'Belmont', 'Colma'].sample(2),
    phones_attributes: [
      {
        country_prefix: Faker::PhoneNumber.country_code,
        department: 'Food Pantry',
        extension: Faker::PhoneNumber.extension,
        number: Faker::PhoneNumber.cell_phone,
        number_type: %w[voice hotline sms tty fax].sample,
        vanity_number: Faker::PhoneNumber.cell_phone
      }
    ],
    regular_schedules_attributes: [
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      },
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      },
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      },
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      },
      {
        weekday: %w[Monday Tuesday Friday Wednesday Thursday].sample,
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample
      }
    ],
    holiday_schedules_attributes: [
      {
        closed: %w[false true].sample,
        start_date: Faker::Date.between(1.month.ago, Date.today),
        end_date: Faker::Date.between(3.days.ago, Date.today),
        opens_at: ['9:30', '8:00'].sample,
        closes_at: ['5:00 PM', '4:00 PM'].sample,
      }
    ]
  })
end