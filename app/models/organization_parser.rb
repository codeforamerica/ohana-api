class OrganizationParser
  attr_accessor :row, :organization

  def self.execute(row)
    instance = new(row)
    instance.save_organization
    instance.organization.reload
  end

  def initialize(row)
    @row = row
  end

  def save_organization
    @organization = Organization.new(**organization_data)
    contact = @organization.contacts.build(**contact_data)
    @organization.save!
    create_phone(contact.reload)
  end

  private

  def organization_data
    {
      alternate_name:     @row['B1AltName'],
      description:        @row['B1Description'],
      email:              @row['B1Email'],
      name:               @row['B1OrgName'],
      website:            "http://#{@row['B1Website']}",
      twitter:            @row['B1Twitter'],
      facebook:           @row['B1Facebook'],
      linkedin:           @row['B1LinkedIn']
    }
  end

  def contact_data
    {
      organization_id:    @organization.id,
      name:               @row['A1Name'],
      title:              @row['A1Title'],
      email:              @row['A1Email']
    }
  end

  def create_phone(contact)
    attr = phone_data(contact)
    phone = @organization.phones.build(**attr)
    phone.contact = contact
    phone.save!
  end

  def phone_data(contact)
    {
      contact:            contact,
      number:             row['A1Phone'],
      number_type:        'sms'#TO-DO ask for this
    }
  end
end
