# This file should contain all the record creation needed to seed the database
# with its default values. The data can then be loaded with rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Set up test users for the Developer Portal.
Kernel.puts 'Setting up first test user...'
user = User.new name: 'First User',
                email: 'user@example.com',
                password: 'mong01dtest',
                password_confirmation: 'mong01dtest'
user.skip_confirmation!
user.save
user.confirm

Kernel.puts 'Setting up second test user...'
user2 = User.new name: 'Second User',
                 email: 'user2@example.com',
                 password: 'mong01dtest',
                 password_confirmation: 'mong01dtest'
user2.skip_confirmation!
user2.save
user2.confirm

# Set up test users for the Admin Interface.
Kernel.puts 'Setting up first test admin...'
admin = Admin.new name: 'admin with custom domain name',
                  email: 'ohana@samaritanhouse.com',
                  password: 'ohanatest',
                  password_confirmation: 'ohanatest'
admin.skip_confirmation!
admin.save
admin.confirm

Kernel.puts 'Setting up second test admin...'
admin2 = Admin.new name: 'admin with generic email',
                   email: 'ohana@gmail.com',
                   password: 'ohanatest',
                   password_confirmation: 'ohanatest'
admin2.skip_confirmation!
admin2.save
admin2.confirm

Kernel.puts 'Setting up test super admin...'
admin3 = Admin.new name: 'Super Admin',
                   email: 'masteradmin@ohanapi.org',
                   password: 'ohanatest',
                   password_confirmation: 'ohanatest'
admin3.skip_confirmation!
admin3.super_admin = true
admin3.save
admin3.confirm

Kernel.puts 'Setting up events...'
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

Kernel.puts 'Setting up BlogPost default Tags...'
['featured', 'front page'].each do |tag|
  if Tag.find_by_name(tag).blank?
    Tag.create!(
        name: tag
    )
  end
end

Kernel.puts 'Setting up BlogPost...'
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
