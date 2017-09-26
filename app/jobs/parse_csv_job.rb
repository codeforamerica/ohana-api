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
      taxonomy_id_array = assign_taxonomies(row)
      @@orgs_map.push(map_to_organizations(row))
      @@locations_map.push(map_to_locations(row, 'L1'))
      @@addresses_map.push(map_to_addresses(row, 'L1'))
      @@mail_addresses_map.push(map_to_mail_addresses(row))
      @@contacts_map.push(map_to_contacts(row))
      @@phones_map.push(map_to_phones(row))
      @@services_map.push(map_to_services(row, 'S1', taxonomy_id_array))
      $i = 2
      $num = 5
      while $i <= $num
        location_key = 'L' + $i.to_s
        service_key = 'S' + $i.to_s
        if !row[location_key<<'LocName'].nil?
          @@locations_map.push(map_to_locations(row, 'L'<<$i.to_s))
          @@addresses_map.push(map_to_addresses(row, 'L'<<$i.to_s))
        end
        if !row[service_key<<'ServiceName'].nil?
          @@services_map.push(map_to_services(row, 'S'<<$i.to_s, taxonomy_id_array))
        end
        $i += 1
      end
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

  def map_to_locations(row, key)
    @@location_id += 1
    {
      id:                 @@location_id,
      organization_id:    @@org_id,
      accessibility:      nil,
      admin_emails:       nil,
      alternate_name:     nil,
      description:        'description',
      email:              nil,
      languages:          nil,
      latitude:           nil,
      longitude:          nil,
      name:               row[key + 'LocName'],
      transportation:     nil,
      virtual:            nil,
      website:            nil,
    }
  end

  def map_to_addresses(row, key)
    @@address_id += 1
    {
      id:                 @@address_id,
      location_id:        @@location_id,
      address_1:          row[key + 'Street1'],
      address_2:          row[key + 'Street2'],
      city:               row[key + 'City'],
      state_province:     row[key + 'State'],
      postal_code:        row[key + 'ZIP'],
      country:            'US',
    }
  end

  def map_to_mail_addresses(row)
    @@mail_address_id += 1
    {
      id:                 @@mail_address_id,
      location_id:        @@location_id,
      attention:          row['B1OrgName'],
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
      number_type:        'voice',
      vanity_number:      nil,
      country_prefix:     nil,
    }
  end

  def map_to_services(row, key, taxonomy_array)
    @@service_id += 1
    {
      id:                     @@service_id,
      location_id:            @@location_id,
      program_id:             nil,
      accepted_payments:      nil,
      alternate_name:         nil,
      description:            'desc',
      eligibility:            nil,
      email:                  nil,
      fees:                   row[key + 'Fee'],
      funding_sources:        nil,
      application_process:    nil,
      interpretation_sources: nil,
      keywords:               nil,
      languages:              nil,
      name:                   row[key+ 'ServiceName'],
      required_documents:     nil,
      service_areas:          nil,
      status:                 'active',
      wait_time:              nil,
      website:                row[key + 'URL'],
      taxonomy_ids:           taxonomy_array.join(',')
    }
  end

  def add_subcategory_id(array, categories_from_db, category_int, column)
   subcats_from_db = categories_from_db['second_level'][category_int]['third_level']
   subcats = column.split(', ')
   subcats.each do |subcat|
     subcats_from_db.each do |subcat_from_db|
       if subcat === subcat_from_db["@title"]
         array.push(subcat_from_db["@id"])
       end
     end
   end
 end

 def add_other_tax_id(array, data_from_db, column)
   focus = column.split(', ')
   focus.each do |type|
     data_from_db['second_level'].each do |d|
       if type === d["@title"]
         array.push(d["@id"])
       end
     end
   end
 end

 def assign_taxonomies(row)
   taxonomy_id_array = []
   file = File.read("/Users/katepiette/ohana-api/data/oe.json")
   json = JSON.parse(file)

   # CATEGORIES
   categories_from_db = json['taxonomy']['top_level'][0]
   categories = row['S1Categories'].split(', ')
   categories.each do |category|
     case category
     when 'Financial Management'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 0, row['S1FinanceSub'])
     when 'Capital'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 1, row['S1CapitalSub'])
     when 'Legal Services'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 2, row['S1LegalSub'])
     when 'Marketing/Sales'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 3, row['S1MarketingSub'])
     when 'Networking'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 4, row['S1NetworkingSub'])
     when 'Manufacturing/Logistics'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 5, row['S1ManufacturingSub'])
     when 'Procurement'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 6, row['S1ProcurementSub'])
     when 'Planning/Management'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 7, row['S1PlanningSub'])
     when 'R&D/Commercialization'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 8, row['S1RDSub'])
     when 'Regulatory Compliance'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 9, row['S1RegulatorySub'])
     when 'Physical Space'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 10, row['S1SpaceSub'])
     when 'Mentoring/Counseling'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 11, row['S1MentoringSub'])
     when 'Human Resources & Workforce Development'
       add_subcategory_id(taxonomy_id_array, categories_from_db, 12, row['S1HRSub'])
     end
   end
   # BUSINESS TYPES
   if !(row['S1Type'].nil?)
     business_types_from_db = json['taxonomy']['top_level'][1]
     add_other_tax_id(taxonomy_id_array, business_types_from_db, row['S1Type'])
   end
   # BUSINESS STAGES
   if !(row['S1Stage'].nil?)
     business_stages_from_db = json['taxonomy']['top_level'][2]
     add_other_tax_id(taxonomy_id_array, business_stages_from_db, row['S1Stage'])
   end
   # UNDERSERVED COMMUNITIES
   if !(row['S1Community'].nil?)
     communities_from_db = json['taxonomy']['top_level'][3]
     add_other_tax_id(taxonomy_id_array, communities_from_db, row['S1Community'])
   end
   # INDUSTRIES
   if !(row['S1Industry'].nil?)
     industries_from_db = json['taxonomy']['top_level'][4]
     add_other_tax_id(taxonomy_id_array, industries_from_db, row['S1Industry'])
   end
   taxonomy_id_array
 end
end

if __FILE__ == $0
   parser = ParseCsvJob.new
   parser.parse_csv()
 end
