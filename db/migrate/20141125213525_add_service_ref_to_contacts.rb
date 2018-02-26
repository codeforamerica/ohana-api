class AddServiceRefToContacts < ActiveRecord::Migration
  def change
    add_reference :contacts, :service, index: true
  end
end
