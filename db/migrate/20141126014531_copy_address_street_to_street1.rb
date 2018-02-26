class CopyAddressStreetToStreet1 < ActiveRecord::Migration
  def up
    execute "update addresses set street_1 = street"
  end

  def down
    execute "update addresses set street = street_1"
  end
end
