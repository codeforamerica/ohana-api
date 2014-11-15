task remove_test_users_and_admins: :environment do
  %w(user@example.com user2@example.com).each do |email|
    User.find_by_email(email).destroy
  end

  %w(ohana@samaritanhouse.com ohana@gmail.com
     masteradmin@ohanapi.org).each do |email|
    Admin.find_by_email(email).destroy
  end
end
