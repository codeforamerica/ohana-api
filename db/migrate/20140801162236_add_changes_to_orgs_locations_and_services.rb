class AddChangesToOrgsLocationsAndServices < ActiveRecord::Migration
  def change
    %w(organizations locations services).each do |table|
      add_column table, :last_changes, :text
      add_column table, :last_changed_id, :integer
    end
  end
end
