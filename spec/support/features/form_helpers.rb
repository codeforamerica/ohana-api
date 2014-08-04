module Features
  module FormHelpers
    def reset_accessibility
      within_fieldset('accessibility') do
        all('input[type=checkbox]').each do |checkbox|
          uncheck checkbox[:id]
        end
      end
      click_button 'Save changes'
    end

    def set_all_accessibility
      within_fieldset('accessibility') do
        all('input[type=checkbox]').each do |checkbox|
          check checkbox[:id]
        end
      end
      click_button 'Save changes'
    end

    def add_street_address(options = {})
      click_link 'Add a street address'
      update_street_address(options)
      click_button 'Save changes'
    end

    def update_street_address(options = {})
      fill_in 'location_address_attributes_street', with: options[:street]
      fill_in 'location_address_attributes_city', with: options[:city]
      fill_in 'location_address_attributes_state', with: options[:state]
      fill_in 'location_address_attributes_zip', with: options[:zip]
      click_button 'Save changes'
    end

    def add_mailing_address(options = {})
      click_link 'Add a mailing address'
      update_mailing_address(options)
      click_button 'Save changes'
    end

    def update_mailing_address(options = {})
      fill_in 'location_mail_address_attributes_attention', with: options[:attention]
      fill_in 'location_mail_address_attributes_street', with: options[:street]
      fill_in 'location_mail_address_attributes_city', with: options[:city]
      fill_in 'location_mail_address_attributes_state', with: options[:state]
      fill_in 'location_mail_address_attributes_zip', with: options[:zip]
    end

    def remove_street_address
      click_link 'Delete this address permanently'
      click_button 'Save changes'
    end

    def remove_mail_address
      click_link 'Delete this mailing address permanently'
      click_button 'Save changes'
    end

    def add_contact(options = {})
      click_link 'Add a contact'
      update_contact(options)
    end

    def update_contact(options = {})
      within('.contacts') do
        fill_in find(:xpath, './/input[contains(@name, "[name]")]')[:id], with: options[:name]
        fill_in find(:xpath, './/input[contains(@name, "[title]")]')[:id], with: options[:title]
        fill_in find(:xpath, './/input[contains(@name, "[email]")]')[:id], with: options[:email]
        fill_in find(:xpath, './/input[contains(@name, "[phone]")]')[:id], with: options[:phone]
        fill_in find(:xpath, './/input[contains(@name, "[fax]")]')[:id], with: options[:fax]
        fill_in find(:xpath, './/input[contains(@name, "[extension]")]')[:id], with: options[:extension]
      end
    end

    def delete_contact
      click_link 'Delete this contact permanently'
      click_button 'Save changes'
    end

    def add_two_emails
      click_link 'Add a general email'
      fill_in 'location[emails][]', with: 'foo@ruby.com'
      click_link 'Add a general email'
      emails = all(:xpath, "//input[@name='location[emails][]']")
      fill_in emails[-1][:id], with: 'ruby@foo.com'
      click_button 'Save changes'
    end

    def delete_all_emails
      find_link('Delete this email permanently', match: :first).click
      find_link('Delete this email permanently', match: :first).click
      click_button 'Save changes'
    end

    def add_fax(options = {})
      click_link 'Add a fax number'
      update_fax(options)
    end

    def update_fax(options = {})
      within('.faxes') do
        fill_in find(:xpath, './/input[contains(@name, "[number]")]')[:id], with: options[:number]
        fill_in find(:xpath, './/input[contains(@name, "[department]")]')[:id], with: options[:department]
      end
    end

    def delete_fax
      click_link 'Delete this fax permanently'
      click_button 'Save changes'
    end

    def add_phone(options = {})
      click_link 'Add a phone number'
      update_phone(options)
    end

    def update_phone(options = {})
      within('.phones') do
        fill_in find(:xpath, './/input[contains(@name, "[number]")]')[:id], with: options[:number]
        select_field = find(:xpath, './/select[contains(@name, "[number_type]")]')[:id]
        select(options[:number_type], from: select_field)
        fill_in find(:xpath, './/input[contains(@name, "[department]")]')[:id], with: options[:department]
        fill_in find(:xpath, './/input[contains(@name, "[extension]")]')[:id], with: options[:extension]
        fill_in find(:xpath, './/input[contains(@name, "[vanity_number]")]')[:id], with: options[:vanity_number]
      end
    end

    def delete_phone
      click_link 'Delete this phone permanently'
      click_button 'Save changes'
    end

    def add_two_admins
      click_link 'Add an admin email'
      fill_in 'location[admin_emails][]', with: 'moncef@foo.com'
      click_link 'Add an admin email'
      admins = all(:xpath, "//input[contains(@name, '[admin_emails]')]")
      fill_in admins[-1][:id], with: 'moncef@otherlocation.com'
      click_button 'Save changes'
    end

    def delete_all_admins
      find_link('Delete this admin permanently', match: :first).click
      find_link('Delete this admin permanently', match: :first).click
      click_button 'Save changes'
    end

    def add_two_urls
      click_link 'Add a website'
      fill_in find(:xpath, "//input[@type='url']")[:id], with: 'http://ruby.com'
      click_link 'Add a website'
      urls = all(:xpath, "//input[@type='url']")
      fill_in urls[-1][:id], with: 'http://monfresh.com'
      click_button 'Save changes'
    end

    def delete_all_urls
      find_link('Delete this website permanently', match: :first).click
      find_link('Delete this website permanently', match: :first).click
      click_button 'Save changes'
    end

    def fill_in_all_required_fields
      fill_in 'location_organization_id', with: 'Parent Agency'
      fill_in 'location_name', with: 'New Parent Agency location'
      fill_in 'location_description', with: 'new description'
      click_link 'Add a street address'
      fill_in 'location_address_attributes_street', with: '123 Main St.'
      fill_in 'location_address_attributes_city', with: 'Belmont'
      fill_in 'location_address_attributes_state', with: 'CA'
      fill_in 'location_address_attributes_zip', with: '12345'
    end

    def add_two_keywords
      click_link 'Add a keyword'
      fill_in 'service[keywords][]', with: 'homeless'
      click_link 'Add a keyword'
      keywords = page.
        all(:xpath, "//input[@name='service[keywords][]']")
      fill_in keywords[-1][:id], with: 'CalFresh'
      click_button 'Save changes'
    end

    def delete_all_keywords
      find_link('Delete this keyword permanently', match: :first).click
      find_link('Delete this keyword permanently', match: :first).click
      click_button 'Save changes'
    end

    def add_two_service_areas
      click_link 'Add a service area'
      fill_in 'service[service_areas][]', with: 'Belmont'
      click_link 'Add a service area'
      service_areas = page.
        all(:xpath, "//input[@name='service[service_areas][]']")
      fill_in service_areas[-1][:id], with: 'Atherton'
      click_button 'Save changes'
    end

    def delete_all_service_areas
      find_link('Delete this service area permanently', match: :first).click
      find_link('Delete this service area permanently', match: :first).click
      click_button 'Save changes'
    end
  end
end
