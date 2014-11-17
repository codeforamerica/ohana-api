include ParentAssigner

class ContactPresenter < Struct.new(:row)
  def to_contact
    contact = Contact.find_or_initialize_by(id: row[:id].to_i)
    contact.attributes = row
    assign_parents_for(contact, row)
    contact
  end
end
