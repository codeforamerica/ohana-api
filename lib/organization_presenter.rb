include EntityPresenter

class OrganizationPresenter < Struct.new(:row)
  def to_org
    org = Organization.find_or_initialize_by(id: row[:id].to_i)
    to_array(row, :accreditations, :licenses, :funding_sources)
    org.attributes = row
    org
  end
end
