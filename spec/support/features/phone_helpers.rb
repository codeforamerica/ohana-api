module Features
  module PhoneHelpers
    def add_phone(options = {})
      click_link 'Add a new phone number'
      update_phone(options)
    end

    def update_phone(options = {})
      within('.phones') do
        fill_in_phone_text_fields(options)
        select(options[:number_type], from: number_type) if options[:number_type]
      end
    end

    def fill_in_phone_text_fields(options)
      fill_in number, with: options[:number]
      fill_in department, with: options[:department]
      fill_in extension, with: options[:extension]
      fill_in vanity_number, with: options[:vanity_number]
    end

    def number
      find(:xpath, './/input[contains(@name, "[number]")]')[:id]
    end

    def department
      find(:xpath, './/input[contains(@name, "[department]")]')[:id]
    end

    def extension
      find(:xpath, './/input[contains(@name, "[extension]")]')[:id]
    end

    def vanity_number
      find(:xpath, './/input[contains(@name, "[vanity_number]")]')[:id]
    end

    def number_type
      find(:xpath, './/select[contains(@name, "[number_type]")]')[:id]
    end

    def delete_phone
      click_link 'Delete this phone permanently'
      click_button 'Save changes'
    end
  end
end
