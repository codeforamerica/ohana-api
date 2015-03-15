class UpdateNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :services, :application_process, true
  end
end
