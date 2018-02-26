class AddServiceRefToPhones < ActiveRecord::Migration
  def change
    add_reference :phones, :service, index: true
  end
end
