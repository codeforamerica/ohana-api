class CopyMailAddressStreetToStreet1 < ActiveRecord::Migration
  def up
    execute "update mail_addresses set street_1 = street"
  end

  def down
    execute "update mail_addresses set street = street_1"
  end
end
