class AddOrganizationRefToPhones < ActiveRecord::Migration
  def change
    add_reference :phones, :organization, index: true
  end
end
