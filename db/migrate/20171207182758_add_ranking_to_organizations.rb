class AddRankingToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :rank, :integer
  end
end
