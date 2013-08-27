class Schedule
  include Mongoid::Document

  field :day, :type => Integer
  field :open, type: TimeField.new(format: 'HH:MM')
  field :close, type: TimeField.new(format: 'HH:MM')
  field :holiday, type: Time

  embedded_in :location
  embedded_in :service

  # A days constant
  DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

  def day_name
    DAYS[self.day]
  end

  def create_hours(params={})
    start_time = params[:start_time] ? params[:start_time] : 6.hours
    end_time = params[:end_time] ? params[:end_time] : 23.hours
    increment = params[:increment] ? params[:increment] : 5.minutes
    Array.new(1 + (end_time - start_time)/increment) do |i|
      (Time.now.midnight + (i*increment) + start_time).strftime("%H:%M")
    end
  end
end