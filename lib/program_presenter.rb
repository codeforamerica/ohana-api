class ProgramPresenter < Struct.new(:row)
  def to_program
    program = Program.find_or_initialize_by(id: row[:id].to_i)
    program.attributes = row
    program.organization_id = row[:organization_id].to_i
    program
  end
end
