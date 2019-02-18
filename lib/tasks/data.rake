task data: :environment do
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
      admin_id: 3,
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
      admin_id: 3,
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
      admin_id: 3,
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
  locations_count = Location.count
  ActiveRecord::Base.connection.execute("select setval('locations_id_seq', #{locations_count + 1});")

  Kernel.puts 'Setting up Location for Organization...'
  organization = Organization.find(5)
  location_name = Faker::Address.street_address

  organization.locations.create!(
    description: Faker::Lorem.paragraph,
    name: location_name,
    active: true,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    virtual: false,
    address_attributes: {
      address_1: location_name,
      city: Faker::Address.city,
      postal_code: Faker::Address.postcode,
      country: Faker::Address.country_code,
      state_province: Faker::Address.state_abbr
    }
  )
end
