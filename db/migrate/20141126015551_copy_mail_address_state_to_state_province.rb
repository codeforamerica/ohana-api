class CopyMailAddressStateToStateProvince < ActiveRecord::Migration
  def up
    execute "update mail_addresses set state_province = state"
  end

  def down
    execute "update mail_addresses set state = state_province"
  end
end
