class ReplaceLocationUrlsWithWebsite < ActiveRecord::Migration
  def change
    add_column :locations, :website, :string
    remove_column :locations, :urls, :string
    add_index :locations, :website, using: 'gin'
  end
end
