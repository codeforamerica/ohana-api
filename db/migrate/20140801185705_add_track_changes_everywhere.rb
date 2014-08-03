class AddTrackChangesEverywhere < ActiveRecord::Migration
  def change
    %w(addresses contacts faxes mail_addresses phones).each do |table|
      add_column table, :last_changes, :text
      add_column table, :last_changed_id, :integer
    end
  end
end
