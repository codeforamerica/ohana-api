class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.text :name, null: false
      t.text :oe_id, null: false
      t.text :slug

      t.timestamps
    end
    add_index :categories, :slug, unique: true
  end
end
