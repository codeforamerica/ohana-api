class LocationPresenter < Struct.new(:row, :addresses)
  def to_location
    location = Organization.find(row[:organization_id]).
               locations.find_or_initialize_by(id: row[:id].to_i)
    transform_fields(row)
    location.attributes = row
    location
  end

  def transform_fields(row)
    to_array(row, :accessibility, :admin_emails, :languages)
    row[:virtual] = false if row[:virtual].blank?
    assign_address_attributes(row)
  end

  def assign_address_attributes(row)
    return if row[:virtual] == true || matching_address(row[:id]).blank?
    row[:address_attributes] = address_attributes_for(row[:id])
  end

  def address_attributes_for(id)
    matching_address(id).except(:id)
  end

  def matching_address(id)
    addresses.select { |a| a[:location_id] == id }.first
  end

  def to_array(row, *fields)
    fields.each do |field|
      if row[field].blank?
        row[field] = []
      else
        row[field] = row[field].split(',').map(&:squish)
      end
    end
  end
end
