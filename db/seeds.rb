# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts '===> Setting up first test user...'
user = User.create! :name => 'First User',
                    :email => 'user@example.com',
                    :password => 'mong01dtest',
                    :password_confirmation => 'mong01dtest'
user.confirm!

puts '===> Setting up second test user...'
user2 = User.create! :name => 'Second User',
                     :email => 'user2@example.com',
                     :password => 'mong01dtest',
                     :password_confirmation => 'mong01dtest'
user2.confirm!

puts '===> Setting up admin user...'
admin = Admin.create! :name => 'Admin User',
                          :email => 'admin@example.com',
                          :password => 'iholdthekeys',
                          :password_confirmation => 'iholdthekeys',
                          :role => "admin"
