module Features
  module ScheduleHelpers
    def add_hour(options = {})
      click_link 'Add hours of operation'
      update_hours(options)
    end

    def update_hours(options = {})
      within('.hours') do
        select(options[:weekday], from: weekday) if options[:weekday]
        select_opening_hours(options)
        select_closing_hours(options)
      end
    end

    def add_holiday_schedule(options = {})
      click_link 'Add holiday schedule'
      update_holiday_schedule(options)
    end

    def update_holiday_schedule(options = {})
      within('.holiday-hours') do
        select_start_date(options)
        select_end_date(options)
        select(options[:closed], from: closed) if options[:closed]
        select_opening_hours(options)
        select_closing_hours(options)
      end
    end

    def select_start_date(options)
      select(options[:start_month], from: start_month) if options[:start_month]
      select(options[:start_day], from: start_day) if options[:start_day]
    end

    def select_end_date(options)
      select(options[:end_month], from: end_month) if options[:end_month]
      select(options[:end_day], from: end_day) if options[:end_day]
    end

    def select_opening_hours(options)
      select(options[:opens_at_hour], from: opens_at_hour) if options[:opens_at_hour]
      select(options[:opens_at_minute], from: opens_at_minute) if options[:opens_at_minute]
    end

    def select_closing_hours(options)
      select(options[:closes_at_hour], from: closes_at_hour) if options[:closes_at_hour]
      select(options[:closes_at_minute], from: closes_at_minute) if options[:closes_at_minute]
    end

    def start_month
      find(:xpath, './/select[contains(@name, "[start_date(2i)]")]')[:id]
    end

    def start_day
      find(:xpath, './/select[contains(@name, "[start_date(3i)]")]')[:id]
    end

    def end_month
      find(:xpath, './/select[contains(@name, "[end_date(2i)]")]')[:id]
    end

    def end_day
      find(:xpath, './/select[contains(@name, "[end_date(3i)]")]')[:id]
    end

    def closed
      find(:xpath, './/select[contains(@name, "[closed]")]')[:id]
    end

    def opens_at_hour
      find(:xpath, './/select[contains(@name, "[opens_at(4i)")]')[:id]
    end

    def opens_at_minute
      find(:xpath, './/select[contains(@name, "[opens_at(5i)")]')[:id]
    end

    def closes_at_hour
      find(:xpath, './/select[contains(@name, "[closes_at(4i)")]')[:id]
    end

    def closes_at_minute
      find(:xpath, './/select[contains(@name, "[closes_at(5i)")]')[:id]
    end

    def weekday
      find(:xpath, './/select[contains(@name, "[weekday]")]')[:id]
    end
  end
end
