OrganizationPresenter = Struct.new(:row) do
  include EntityPresenter

  def to_org
    org = Organization.find_or_initialize_by(id: row[:id].to_i)
    to_array(row, :accreditations, :licenses, :funding_sources)
    org.attributes = row
    org.id = row[:id].to_i
    org
  end
end
