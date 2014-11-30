class CreateHolidaySchedules < ActiveRecord::Migration
  def change
    create_table :holiday_schedules do |t|
      t.references :location, index: true
      t.references :service, index: true
      t.boolean :closed, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.time :opens_at
      t.time :closes_at
    end
  end
end
