class AddFieldsToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :alternate_name, :string
    add_column :locations, :virtual, :boolean, default: false
  end
end
