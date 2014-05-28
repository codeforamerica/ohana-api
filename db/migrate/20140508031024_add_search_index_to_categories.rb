class AddSearchIndexToCategories < ActiveRecord::Migration
  def up
    execute "create index categories_name on categories using gin(to_tsvector('english', name))"
  end

  def down
    execute "drop index categories_name"
  end
end
