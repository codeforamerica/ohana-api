class AddProgramRefToServices < ActiveRecord::Migration
  def change
    add_reference :services, :program, index: true
  end
end
