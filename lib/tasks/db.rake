BLOG_POST_CATEGORIES = ['featured', 'front page', 'soccer', 'games', 'food',
                        'drink', 'programming', 'study', 'entertainment']
namespace :db do
  namespace :seed do
    task all: %i[dev]
    desc 'Data for development'
    task :dev, [:path] => :environment do |_, _args|
      Kernel.puts 'Setting up three new Organizations...'
      ActiveRecord::Base.connection.execute('TRUNCATE organizations RESTART IDENTITY;')
      Location.delete_all
      Phone.delete_all
      MailAddress.delete_all
      RegularSchedule.delete_all
      HolidaySchedule.delete_all
      Service.delete_all
      Contact.delete_all
      ActiveRecord::Base.connection.execute('TRUNCATE friendly_id_slugs RESTART IDENTITY;')

      3.times do
        create_organization
      end

      Kernel.puts 'Setting up one Location for Organization #1...'
      create_locations_for_organization(1)

      2.times do
        Kernel.puts 'Setting up two Locations for Organization #2...'
        create_locations_for_organization(2)
      end

      3.times do
        Kernel.puts 'Setting up 3 Locations for Organization #3...'
        create_locations_for_organization(3)
      end

      Event.delete_all
      Kernel.puts 'Setting up 38 events for Organization #1...'
      38.times do |index|
        create_events_for_organization(1, index, DateTime.now)
      end
      Event.first.update(is_featured: true)
      Event.last.update(is_featured: true)

      Kernel.puts 'Setting up 3 events for Organization #2...'
      3.times do |index|
        create_events_for_organization(2, index, 1.month.from_now)
      end
      Event.last.update(is_featured: true)

      Kernel.puts 'Setting up 8 events for Organization #3...'
      8.times do |index|
        create_events_for_organization(3, index, 2.month.from_now)
      end
      Event.last.update(is_featured: true)

      Kernel.puts 'Setting up BlogPost default Tags...'
      ActiveRecord::Base.connection.execute('TRUNCATE tags RESTART IDENTITY;')
      BlogPost.delete_all

      BLOG_POST_CATEGORIES.each do |tag|
        Tag.create!(
          name: tag
        )
      end

      Kernel.puts 'Setting up 32 BlogPost for Organization #1...'
      32.times do |index|
        create_blog_posts_for_organiation(1, index, 100)
      end

      Kernel.puts 'Setting up 3 BlogPost for Organization #2...'
      3.times do |index|
        create_blog_posts_for_organiation(2, index, 20)
      end

      Kernel.puts 'Setting up 8 BlogPost for Organization #3...'
      8.times do |index|
        create_blog_posts_for_organiation(3, index, 200)
      end
    end
  end
end

def create_organization
  Faker::Config.locale = 'en-US'
  organization = Organization.create!(
    name: Faker::Company.name,
    alternate_name: Faker::Company.name,
    date_incorporated: Faker::Date.between(8.months.ago, Date.today),
    description: Faker::Lorem.paragraph(150),
    website: Faker::Internet.url,
    twitter: Faker::Internet.url,
    facebook: Faker::Internet.url,
    linkedin: Faker::Internet.url,
    logo_url: Faker::Avatar.image,
    approval_status: %w[pending approved denied].sample,
    is_published: %w[false true].sample,
    user_id: 1,
    funding_sources: ['Donations', 'Grants', 'DC Government'].sample(2),
    email: Faker::Internet.email,
    legal_status: ['Nonprofit'].sample,
    tax_id: Faker::IDNumber.valid,
    tax_status: Faker::Company.duns_number,
    licenses: ['State Health Inspection License', Faker::Company.industry].sample(1),
    accreditations: ['BBB', 'State Board of Education', Faker::Company.industry].sample(2)
  )
  organization.phones.create!(
    country_prefix: Faker::PhoneNumber.country_code,
    department: 'Food Pantry',
    extension: Faker::PhoneNumber.extension,
    number: Faker::PhoneNumber.cell_phone,
    number_type: %w[voice hotline sms tty fax].sample,
    vanity_number: Faker::PhoneNumber.cell_phone
  )
  organization.contacts.create!(
    department: 'Food Pantry',
    email: Faker::Internet.email,
    name: Faker::Company.name,
    title: Faker::Job.title
  )
end

def create_events_for_organization(organization_id, index, month)
  date = Faker::Time.between(month.beginning_of_month + 1.day, month.end_of_month - 1.day)
  Event.create!(
    title: Faker::Job.title,
    posted_at: date,
    starting_at: date,
    ending_at: date + index.hours + 1.hour,
    city: Faker::Address.city,
    body: Faker::Lorem.paragraph,
    is_featured: false,
    street_1: Faker::Address.street_address,
    street_2: Faker::Address.street_address,
    organization_id: organization_id,
    user_id: 3,
    state_abbr: Faker::Address.state_abbr,
    zip: Faker::Address.zip,
    phone: Faker::PhoneNumber.cell_phone,
    external_url: Faker::Internet.url
  )
end

def create_blog_posts_for_organiation(organization_id, index, title_size)
  blog = BlogPost.new(
    title: Faker::Lorem.paragraph(title_size),
    posted_at: Faker::Time.between(DateTime.now - index.hours, DateTime.now),
    is_published: %w[false true].sample,
    user_id: 3,
    body: Faker::Lorem.paragraph(200),
    blog_post_attachments_attributes: [
      {
        file_type: %w[video image audio].sample,
        file_url: Faker::Avatar.image,
        file_legend: Faker::Lorem.sentence,
        order: rand(1..3)
      }
    ],
    organization_id: organization_id
  )
  blog.category_list = BLOG_POST_CATEGORIES.sample
  blog.save
end

def create_locations_for_organization(organization_id)
  Faker::Config.locale = 'en-US'
  location_name = Faker::Address.street_address
  organization = Organization.find(organization_id)
  location = organization.locations.create(
    accessibility: %w[cd deaf_interpreter disabled_parking elevator ramp restroom tape_braille tty wheelchair wheelchair_van].sample(3),
    active: true,
    admin_emails: [Faker::Internet.email],
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
    address_attributes: {
      address_1: location_name,
      city: Faker::Address.city,
      postal_code: Faker::Address.postcode,
      country: Faker::Address.country_code,
      state_province: Faker::Address.state_abbr
    }
  )

  location.create_mail_address(
    attention: Faker::Name.name,
    city: Faker::Address.city,
    state_province: Faker::Address.state_abbr,
    address_1: location_name,
    address_2: Faker::Address.street_address,
    postal_code: Faker::Address.postcode,
    country: Faker::Address.country_code
  )

  location.phones.create(
    country_prefix: Faker::PhoneNumber.country_code,
    department: 'Food Pantry',
    extension: Faker::PhoneNumber.extension,
    number: Faker::PhoneNumber.cell_phone,
    number_type: %w[voice hotline sms tty fax].sample,
    vanity_number: Faker::PhoneNumber.cell_phone
  )

  location.regular_schedules.create(
    [
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
    ]
  )

  location.holiday_schedules.create(
    closed: %w[false true].sample,
    start_date: Faker::Date.between(1.month.ago, Date.today),
    end_date: Faker::Date.between(3.days.ago, Date.today),
    opens_at: ['9:30', '8:00'].sample,
    closes_at: ['5:00 PM', '4:00 PM'].sample
  )

  service = location.services.create(
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
    service_areas: ['Alameda County', 'Belmont', 'Colma'].sample(2)
  )

  service.phones.create(
    country_prefix: Faker::PhoneNumber.country_code,
    department: 'Food Pantry',
    extension: Faker::PhoneNumber.extension,
    number: Faker::PhoneNumber.cell_phone,
    number_type: %w[voice hotline sms tty fax].sample,
    vanity_number: Faker::PhoneNumber.cell_phone
  )

  service.regular_schedules.create(
    [
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
    ]
  )

  service.holiday_schedules.create(
    closed: %w[false true].sample,
    start_date: Faker::Date.between(1.month.ago, Date.today),
    end_date: Faker::Date.between(3.days.ago, Date.today),
    opens_at: ['9:30', '8:00'].sample,
    closes_at: ['5:00 PM', '4:00 PM'].sample
  )
end
