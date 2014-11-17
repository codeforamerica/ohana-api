include ParentAssigner

class ProgramPresenter < Struct.new(:row)
  def to_program
    program = Program.find_or_initialize_by(id: row[:id].to_i)
    program.attributes = row
    assign_parents_for(program, row)
    program
  end
end
