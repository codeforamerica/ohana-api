class CopyAddressZipToPostalCode < ActiveRecord::Migration
  def up
    execute "update addresses set postal_code = zip"
  end

  def down
    execute "update addresses set zip = postal_code"
  end
end
