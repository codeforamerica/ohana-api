task :remove_test_users_and_admins => :environment do
  User.find_by_email('user@example.com').destroy
  User.find_by_email('user2@example.com').destroy
  Admin.find_by_email('ohana@samaritanhouse.com').destroy
  Admin.find_by_email('ohana@gmail.com').destroy
  Admin.find_by_email('masteradmin@ohanapi.org').destroy
end
