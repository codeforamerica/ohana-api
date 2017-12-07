class AddRankingToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :ranking, :integer
  end
end
