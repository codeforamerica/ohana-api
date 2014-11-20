class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.belongs_to :organization
      t.string :name
      t.string :alternate_name

      t.timestamps
    end
    add_index :programs, :organization_id
  end
end
