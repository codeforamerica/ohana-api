class AddCountryPrefixToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :country_prefix, :string
  end
end
