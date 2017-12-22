LocationPresenter = Struct.new(:row, :addresses) do
  include EntityPresenter
  include ParentAssigner

  def to_location
    location = Location.find_or_initialize_by(id: row[:id].to_i)
    transform_fields(location, row)
    location.attributes = row
    assign_parents_for(location, row)
    location
  end

  def transform_fields(location, row)
    to_array(row, :accessibility, :admin_emails, :languages)
    row[:virtual] = false if row[:virtual].blank?
    assign_address_attributes(location, row)
  end

  def assign_address_attributes(location, row)
    return if row[:virtual] == true || matching_address(row[:id]).blank?
    if location.address.blank?
      row[:address_attributes] = address_attributes_for(row[:id])
    else
      update_address_for(location)
    end
  end

  def update_address_for(location)
    location.address.update(address_attributes_for(row[:id]))
  end

  def address_attributes_for(id)
    @attributes ||= matching_address(id).except(:id)
  end

  def matching_address(id)
    @matching_address ||= addresses.detect { |a| a[:location_id] == id }
  end
end
