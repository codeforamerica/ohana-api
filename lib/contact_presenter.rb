class ContactPresenter < Struct.new(:row)
  def to_contact
    contact = Contact.find_or_initialize_by(id: row[:id].to_i)
    contact.attributes = row
    assign_service_for(contact)
    assign_location_for(contact)
    assign_organization_for(contact)
    contact
  end

  def assign_service_for(contact)
    contact.service_id = row[:service_id].to_i
  end

  def assign_location_for(contact)
    contact.location_id = row[:location_id].to_i
  end

  def assign_organization_for(contact)
    contact.organization_id = row[:organization_id].to_i
  end
end
