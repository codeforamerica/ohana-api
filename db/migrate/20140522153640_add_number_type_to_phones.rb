class AddNumberTypeToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :number_type, :string
  end
end
