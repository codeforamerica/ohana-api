class ChangeApplicationProcessToText < ActiveRecord::Migration
  def self.up
    change_column :services, :application_process, :text
  end

  def self.down
    change_column :services, :application_process, :string
  end
end
