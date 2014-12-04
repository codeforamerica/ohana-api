class AddTidToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :tid, :integer
  end
end
