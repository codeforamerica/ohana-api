class CopyAddressStateToStateProvince < ActiveRecord::Migration
  def up
    execute "update addresses set state_province = state"
  end

  def down
    execute "update addresses set state = state_province"
  end
end
