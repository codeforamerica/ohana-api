class ConvertAdminEmailsToArray < ActiveRecord::Migration[5.0]
  def up
    execute "drop index locations_admin_emails"
    change_column :locations, :admin_emails, "text[] USING (string_to_array(admin_emails, '\n- '))", default: []
    add_index :locations, :admin_emails, using: 'gin'

    Location.find_each do |loc|
      clean_emails = loc.admin_emails.drop(1).map { |email| email.strip.gsub("\n", '') }
      loc.update!(admin_emails: clean_emails)
    end
  end

  def down
    execute "drop index index_locations_on_admin_emails"
    change_column :locations, :admin_emails, "text USING (array_to_string(admin_emails, ','))"

    Location.find_each do |loc|
      if loc.admin_emails.blank?
        loc.update!(admin_emails: "--- []\n")
      else
        loc.update!(admin_emails: loc.admin_emails.split(',').to_yaml)
      end
    end

    execute "create index locations_admin_emails on locations using gin(to_tsvector('english', admin_emails))"
  end
end
