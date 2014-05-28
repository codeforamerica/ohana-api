class CreateCategoriesServices < ActiveRecord::Migration
  def change
    create_table :categories_services, id: false do |t|
      t.belongs_to :category, null: false
      t.belongs_to :service,  null: false
    end
    add_index(:categories_services, [:service_id, :category_id], unique: true)
    add_index(:categories_services, [:category_id, :service_id], unique: true)
  end
end
