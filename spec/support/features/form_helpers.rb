module Features
  module FormHelpers
    def reset_accessibility
      within('.accessibility') do
        all('input[type=checkbox]').each do |checkbox|
          uncheck checkbox[:id]
        end
      end
      click_button 'Save changes'
    end

    def set_all_accessibility
      within('.accessibility') do
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
      fill_in 'location_address_attributes_street_1', with: options[:street_1]
      fill_in 'location_address_attributes_city', with: options[:city]
      fill_in 'location_address_attributes_state', with: options[:state]
      fill_in 'location_address_attributes_postal_code', with: options[:postal_code]
      fill_in 'location_address_attributes_country_code', with: options[:country_code]
      click_button 'Save changes'
    end

    def add_mailing_address(options = {})
      click_link 'Add a mailing address'
      update_mailing_address(options)
      click_button 'Save changes'
    end

    def update_mailing_address(options = {})
      fill_in 'location_mail_address_attributes_attention', with: options[:attention]
      fill_in 'location_mail_address_attributes_street_1', with: options[:street_1]
      fill_in 'location_mail_address_attributes_city', with: options[:city]
      fill_in 'location_mail_address_attributes_state', with: options[:state]
      fill_in 'location_mail_address_attributes_postal_code', with: options[:postal_code]
      fill_in 'location_mail_address_attributes_country_code', with: options[:country_code]
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
      click_link 'Add a new contact'
      update_contact(options)
    end

    def update_contact(options = {})
      within('.contacts') do
        fill_in find(:xpath, './/input[contains(@name, "[name]")]')[:id], with: options[:name]
        fill_in find(:xpath, './/input[contains(@name, "[title]")]')[:id], with: options[:title]
        fill_in find(:xpath, './/input[contains(@name, "[email]")]')[:id], with: options[:email]
        fill_in find(:xpath, './/input[contains(@name, "[department]")]')[:id], with: options[:department]
      end
    end

    def delete_contact
      click_link 'Delete this contact permanently'
      click_button 'Save changes'
    end

    def add_two_emails
      click_link 'Add a new general email'
      fill_in 'location[emails][]', with: 'foo@ruby.com'
      click_link 'Add a new general email'
      emails = all(:xpath, "//input[@name='location[emails][]']")
      fill_in emails[-1][:id], with: 'ruby@foo.com'
      click_button 'Save changes'
    end

    def delete_all_emails
      find_link('Delete this email permanently', match: :first).click
      find_link('Delete this email permanently', match: :first).click
      click_button 'Save changes'
    end

    def add_phone(options = {})
      click_link 'Add a new phone number'
      update_phone(options)
    end

    def update_phone(options = {})
      within('.phones') do
        fill_in find(:xpath, './/input[contains(@name, "[number]")]')[:id], with: options[:number]
        select_field = find(:xpath, './/select[contains(@name, "[number_type]")]')[:id]
        select(options[:number_type], from: select_field) if options[:number_type]
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
      find_link('Add a new admin email').trigger('click')
      fill_in 'location[admin_emails][]', with: 'moncef@foo.com'
      find_link('Add a new admin email').trigger('click')
      admins = all(:xpath, "//input[contains(@name, '[admin_emails]')]")
      fill_in admins[-1][:id], with: 'moncef@otherlocation.com'
      click_button 'Save changes'
    end

    def delete_all_admins
      find_link('Delete this admin permanently', match: :first).trigger('click')
      find_link('Delete this admin permanently', match: :first).trigger('click')
      click_button 'Save changes'
    end

    def add_two_urls
      click_link 'Add a new website'
      fill_in find(:xpath, "//input[@type='url']")[:id], with: 'http://ruby.com'
      click_link 'Add a new website'
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
      select2('Parent Agency', 'org-name')
      fill_in 'location_name', with: 'New Parent Agency location'
      fill_in 'location_description', with: 'new description'
      click_link 'Add a street address'
      fill_in 'location_address_attributes_street_1', with: '123 Main St.'
      fill_in 'location_address_attributes_city', with: 'Belmont'
      fill_in 'location_address_attributes_state', with: 'CA'
      fill_in 'location_address_attributes_postal_code', with: '12345'
      fill_in 'location_address_attributes_country_code', with: 'US'
    end

    def select2(value, id, options = {})
      set_select2_value(value, options[:multiple], first("#s2id_#{id}"))

      page.execute_script(%|$('input.select2-input:visible').keyup();|)

      find(:xpath, '//body').
        find("#{drop_container(options[:tag])} li", text: value).click
    end

    def drop_container(tag_option)
      return '.select2-results' unless tag_option == true
      '.select2-drop'
    end

    def set_select2_value(value, multiple_option, container)
      if multiple_option == true
        set_multiple_select2_value(value, container)
      else
        set_single_select2_value(value, container)
      end
    end

    def set_multiple_select2_value(value, container)
      container.find('.select2-choices').click
      within container do
        find('input.select2-input').set(value)
      end
    end

    def set_single_select2_value(value, container)
      container.find('.select2-choice').click
      within '.select2-search' do
        find('input.select2-input').set(value)
      end
    end

    def add_two_keywords
      click_link 'Add a new keyword'
      fill_in 'service[keywords][]', with: 'homeless'
      click_link 'Add a new keyword'
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
      click_link 'Add a new service area'
      fill_in 'service[service_areas][]', with: 'Belmont'
      click_link 'Add a new service area'
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

    def select_date(date, options = {})
      field = options[:from]
      select date.strftime('%Y'), from: "#{field}_1i"
      select date.strftime('%B'), from: "#{field}_2i"
      select date.strftime('%-d'), from: "#{field}_3i"
    end

    def fill_in_required_service_fields
      fill_in 'service_name', with: 'New VRS Services service'
      fill_in 'service_description', with: 'new description'
      fill_in 'service_how_to_apply', with: 'new application process'
      select 'Active', from: 'service_status'
    end

    def add_hour(options = {})
      click_link 'Add hours of operation'
      update_hours(options)
    end

    def update_hours(options = {})
      within('.hours') do
        day = find(:xpath, './/select[contains(@name, "[weekday]")]')[:id]
        select(options[:weekday], from: day) if options[:weekday]

        opens_at_hour = find(:xpath, './/select[contains(@name, "[opens_at(4i)")]')[:id]
        select(options[:opens_at_hour], from: opens_at_hour) if options[:opens_at_hour]

        opens_at_minute = find(:xpath, './/select[contains(@name, "[opens_at(5i)")]')[:id]
        select(options[:opens_at_minute], from: opens_at_minute) if options[:opens_at_minute]

        closes_at_hour = find(:xpath, './/select[contains(@name, "[closes_at(4i)")]')[:id]
        select(options[:closes_at_hour], from: closes_at_hour) if options[:closes_at_hour]

        closes_at_minute = find(:xpath, './/select[contains(@name, "[closes_at(5i)")]')[:id]
        select(options[:closes_at_minute], from: closes_at_minute) if options[:closes_at_minute]
      end
    end
  end
end
