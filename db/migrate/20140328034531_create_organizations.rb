class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.text :name
      t.text :urls
      t.text :slug

      t.timestamps
    end
    add_index :organizations, :slug, unique: true
  end
end
