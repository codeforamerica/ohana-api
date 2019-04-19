class AddIsAllDayToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_all_day, :boolean
  end
end
