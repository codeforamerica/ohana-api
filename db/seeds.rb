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
