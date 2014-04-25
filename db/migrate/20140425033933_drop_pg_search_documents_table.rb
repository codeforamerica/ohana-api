class DropPgSearchDocumentsTable < ActiveRecord::Migration
  def up
    drop_table :pg_search_documents
  end

  def down
  end
end
