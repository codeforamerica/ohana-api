class AddInterpretationServicesToServices < ActiveRecord::Migration
  def change
    add_column :services, :interpretation_services, :text
  end
end
