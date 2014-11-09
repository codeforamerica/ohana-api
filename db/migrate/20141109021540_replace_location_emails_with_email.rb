class ReplaceLocationEmailsWithEmail < ActiveRecord::Migration
  def change
    add_column :locations, :email, :string
    remove_column :locations, :emails, :text
  end
end
