class AddOrganizationRefToContacts < ActiveRecord::Migration
  def change
    add_reference :contacts, :organization, index: true
  end
end
