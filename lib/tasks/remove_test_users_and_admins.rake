task remove_test_users_and_admins: :environment do
  User.includes(:api_applications).destroy_all email: %w[
    user@example.com
    user2@example.com
  ]

  Admin.destroy_all email: %w[
    ohana@samaritanhouse.com
    ohana@gmail.com
    masteradmin@ohanapi.org
  ]
end
