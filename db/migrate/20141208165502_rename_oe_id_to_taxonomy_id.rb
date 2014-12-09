class RenameOeIdToTaxonomyId < ActiveRecord::Migration
  def change
    rename_column :categories, :oe_id, :taxonomy_id
  end
end
