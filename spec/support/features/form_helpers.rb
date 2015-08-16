module Features
  module FormHelpers
    def reset_accessibility
      within('.accessibility') do
        all('input[type=checkbox]').each do |checkbox|
          uncheck checkbox[:id]
        end
      end
      click_button I18n.t('admin.buttons.save_changes')
    end

    def set_all_accessibility
      within('.accessibility') do
        all('input[type=checkbox]').each do |checkbox|
          check checkbox[:id]
        end
      end
      click_button I18n.t('admin.buttons.save_changes')
    end

    def add_street_address(options = {})
      click_link I18n.t('admin.buttons.add_street_address')
      update_street_address(options)
      click_button I18n.t('admin.buttons.save_changes')
    end

    def update_street_address(options = {})
      fill_in 'location_address_attributes_address_1', with: options[:address_1]
      fill_in 'location_address_attributes_city', with: options[:city]
      fill_in 'location_address_attributes_state_province', with: options[:state_province]
      fill_in 'location_address_attributes_postal_code', with: options[:postal_code]
      fill_in 'location_address_attributes_country', with: options[:country]
      click_button I18n.t('admin.buttons.save_changes')
    end

    def add_mailing_address(options = {})
      click_link I18n.t('admin.buttons.add_mailing_address')
      update_mailing_address(options)
      click_button I18n.t('admin.buttons.save_changes')
    end

    def update_mailing_address(options = {})
      fill_in 'location_mail_address_attributes_attention', with: options[:attention]
      fill_in 'location_mail_address_attributes_address_1', with: options[:address_1]
      fill_in 'location_mail_address_attributes_city', with: options[:city]
      fill_in 'location_mail_address_attributes_state_province', with: options[:state_province]
      fill_in 'location_mail_address_attributes_postal_code', with: options[:postal_code]
      fill_in 'location_mail_address_attributes_country', with: options[:country]
    end

    def remove_street_address
      click_link I18n.t('admin.buttons.delete_street_address')
      click_button I18n.t('admin.buttons.save_changes')
    end

    def remove_mail_address
      click_link I18n.t('admin.buttons.delete_mailing_address')
      click_button I18n.t('admin.buttons.save_changes')
    end

    def add_two_admins
      find_link(I18n.t('admin.buttons.add_admin')).trigger('click')
      fill_in 'location[admin_emails][]', with: 'moncef@foo.com'
      find_link(I18n.t('admin.buttons.add_admin')).trigger('click')
      admins = all(:xpath, "//input[contains(@name, '[admin_emails]')]")
      fill_in admins[-1][:id], with: 'moncef@otherlocation.com'
      click_button I18n.t('admin.buttons.save_changes')
    end

    def delete_all_admins
      find_link(I18n.t('admin.buttons.delete_admin'), match: :first).trigger('click')
      find_link(I18n.t('admin.buttons.delete_admin'), match: :first).trigger('click')
      click_button I18n.t('admin.buttons.save_changes')
    end

    def fill_in_all_required_fields
      select2('Parent Agency', 'org-name')
      fill_in 'location_name', with: 'New Parent Agency location'
      fill_in 'location_description', with: 'new description'
      click_link I18n.t('admin.buttons.add_street_address')
      fill_in 'location_address_attributes_address_1', with: '123 Main St.'
      fill_in 'location_address_attributes_city', with: 'Belmont'
      fill_in 'location_address_attributes_state_province', with: 'CA'
      fill_in 'location_address_attributes_postal_code', with: '12345'
      fill_in 'location_address_attributes_country', with: 'US'
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
      click_link I18n.t('admin.buttons.add_keyword')
      fill_in 'service[keywords][]', with: 'homeless'
      click_link I18n.t('admin.buttons.add_keyword')
      keywords = page.
                 all(:xpath, "//input[@name='service[keywords][]']")
      fill_in keywords[-1][:id], with: 'CalFresh'
      click_button I18n.t('admin.buttons.save_changes')
    end

    def delete_all_keywords
      find_link(I18n.t('admin.buttons.delete_keyword'), match: :first).click
      find_link(I18n.t('admin.buttons.delete_keyword'), match: :first).click
      click_button I18n.t('admin.buttons.save_changes')
    end

    def add_two_service_areas
      click_link 'Add a new service area'
      fill_in 'service[service_areas][]', with: 'Belmont'
      click_link 'Add a new service area'
      service_areas = page.
                      all(:xpath, "//input[@name='service[service_areas][]']")
      fill_in service_areas[-1][:id], with: 'Atherton'
      click_button I18n.t('admin.buttons.save_changes')
    end

    def delete_all_service_areas
      find_link('Delete this service area permanently', match: :first).click
      find_link('Delete this service area permanently', match: :first).click
      click_button I18n.t('admin.buttons.save_changes')
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
      select 'Active', from: 'service_status'
    end
  end
end
