class CreateRegularSchedules < ActiveRecord::Migration
  def change
    create_table :regular_schedules do |t|
      t.integer :weekday
      t.time :opens_at
      t.time :closes_at
      t.references :service, index: true
      t.references :location, index: true
    end
    add_index :regular_schedules, :weekday
    add_index :regular_schedules, :opens_at
    add_index :regular_schedules, :closes_at
  end
end
