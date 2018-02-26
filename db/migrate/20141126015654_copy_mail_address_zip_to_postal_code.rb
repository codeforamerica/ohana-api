class CopyMailAddressZipToPostalCode < ActiveRecord::Migration
  def up
    execute "update mail_addresses set postal_code = zip"
  end

  def down
    execute "update mail_addresses set zip = postal_code"
  end
end
