require 'csv'
require 'json'
require 'net/http'

class ParseCsvJob

  @@orgs_map = []
  @@locations_map = []
  @@addresses_map = []
  @@mail_addresses_map = []
  @@contacts_map = []
  @@phones_map = []
  @@services_map = []

  @@org_id = 0
  @@location_id = 0
  @@address_id = 0
  @@mail_address_id = 0
  @@contact_id = 0
  @@phone_id = 0
  @@service_id = 0

  def parse_csv()
    file = File.open("/Users/katepiette/ohana-api/data/city-of-sac-csv/city_of_sac_data.csv")
    CSV.foreach(file, headers: true) do |row|
      @@orgs_map.push(map_to_organizations(row))
      @@locations_map.push(map_to_locations(row))
      @@addresses_map.push(map_to_addresses(row))
      @@mail_addresses_map.push(map_to_mail_addresses(row))
      @@contacts_map.push(map_to_contacts(row))
      @@phones_map.push(map_to_phones(row))
      @@services_map.push(map_to_services(row))
    end
    create_csvs()
  end

  def create_csvs()
    CSV.open("/Users/katepiette/ohana-api/data/organizations.csv", "wb") do |csv|
      csv << @@orgs_map.first.keys
      @@orgs_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/Users/katepiette/ohana-api/data/locations.csv", "wb") do |csv|
      csv << @@locations_map.first.keys
      @@locations_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/Users/katepiette/ohana-api/data/addresses.csv", "wb") do |csv|
      csv << @@addresses_map.first.keys
      @@addresses_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/Users/katepiette/ohana-api/data/mail_addresses.csv", "wb") do |csv|
      csv << @@mail_addresses_map.first.keys
      @@mail_addresses_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/Users/katepiette/ohana-api/data/contacts.csv", "wb") do |csv|
      csv << @@contacts_map.first.keys
      @@contacts_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/Users/katepiette/ohana-api/data/phones.csv", "wb") do |csv|
      csv << @@phones_map.first.keys
      @@phones_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/Users/katepiette/ohana-api/data/services.csv", "wb") do |csv|
      csv << @@services_map.first.keys
      @@services_map.each do |hash|
        csv << hash.values
      end
    end
  end

  def map_to_organizations(row)
    @@org_id += 1
    {
      id:                 @@org_id,
      accreditations:     nil,
      alternate_name:     row['B1AltName'],
      date_incorporated:  nil,
      description:        row['B1Description'],
      email:              row['B1Email'],
      funding_sources:    nil,
      legal_status:       nil,
      licenses:           nil,
      name:               row['B1OrgName'],
      tax_id:             nil,
      tax_status:         nil,
      website:            row['B1Website'],
      twitter:            row['B1Twitter'],
      facebook:           row['B1Facebook'],
      linkedin:           row['B1LinkedIn'],
    }
  end

  def map_to_locations(row)
    @@location_id += 1
    {
      id:                 @@location_id,
      organization_id:    @@org_id,
      accessibility:      nil,
      admin_emails:       nil,
      alternate_name:     nil,
      description:        nil,
      email:              nil,
      languages:          nil,
      latitude:           nil,
      longitude:          nil,
      name:               nil,
      transportation:     nil,
      virtual:            nil,
      website:            nil,
    }
  end

  def map_to_addresses(row)
    @@address_id += 1
    {
      id:                 @@address_id,
      location_id:        @@location_id,
      address_1:          row['L1Street1'],
      address_2:          row['L1Street2'],
      city:               row['L1City'],
      state_province:     row['L1State'],
      postal_code:        row['L1ZIP'],
      country:            'US',
    }
  end

  def map_to_mail_addresses(row)
    @@mail_address_id += 1
    {
      id:                 @@mail_address_id,
      location_id:        nil,
      attention:          nil,
      address_1:          row['M1Street1'],
      address_2:          row['M1Street2'],
      city:               row['M1City'],
      state_province:     row['M1State'],
      postal_code:        row['M1ZIP'],
      country:            'US',
    }
  end

  def map_to_contacts(row)
    @@contact_id += 1
    {
      id:                 @@contact_id,
      location_id:        nil,
      organization_id:    @@org_id,
      service_id:         nil,
      name:               row['A1Name'],
      title:              row['A1Title'],
      email:              row['A1Email'],
      department:         nil,
    }
  end

  def map_to_phones(row)
    @@phone_id += 1
    {
      id:                 @@phone_id,
      contact_id:         @@contact_id,
      location_id:        nil,
      organization_id:    @@org_id,
      service_id:         nil,
      number:             row['A1Phone'],
      extension:          nil,
      department:         nil,
      number_type:        'Work',
      vanity_number:      nil,
      country_prefix:     nil,
    }
  end

  def map_to_services(row)
    @@service_id += 1
    {
      id:                     @@service_id,
      location_id:            nil,
      program_id:             nil,
      accepted_payments:      nil,
      alternate_name:         nil,
      description:            row['S1ServiceDesc'],
      eligibility:            nil,
      email:                  nil,
      fees:                   row['S1Fee'],
      funding_sources:        nil,
      application_process:    nil,
      interpretation_sources: nil,
      keywords:               nil,
      languages:              nil,
      name:                   row['S1ServiceName'],
      required_documents:     nil,
      service_areas:          row['S1ServiceArea'],
      status:                 'active',
      wait_time:              nil,
      website:                row['S1URL'],
      taxonomy_ids:           nil
    }
  end
end

if __FILE__ == $0
   parser = ParseCsvJob.new
   parser.parse_csv()
 end
