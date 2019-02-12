require 'csv'
require 'json'
require 'net/http'

class ParseDataToCsvs
  def initialize
    @orgs_map = []
    @locations_map = []
    @addresses_map = []
    @mail_addresses_map = []
    @contacts_map = []
    @phones_map = []
    @services_map = []

    @org_id = 0
    @location_id = 0
    @address_id = 0
    @mail_address_id = 0
    @contact_id = 0
    @phone_id = 0
    @service_id = 0
  end

  def parse_csv()
    file = File.open("/tmp/ohana-api/data/launchpad_orgs_small.csv")
    CSV.foreach(file, headers: true) do |row|
      @orgs_map.push(map_to_organizations(row))
      @locations_map.push(map_to_locations(row, 'L1'))
      if !row['L1Phone'].nil?
        @phones_map.push(map_to_location_phones(row, 'L1'))
      end
      @addresses_map.push(map_to_addresses(row, 'L1'))
      if !row['M1Street1'].nil?
        @mail_addresses_map.push(map_to_mail_addresses(row))
      end
      if !row['B1OrgContactName'].nil?
        @contacts_map.push(map_to_main_contacts(row))
      end
      @phones_map.push(map_to_phones(row))
      @services_map.push(map_to_services(row, 'S1'))
      if !row['S1Phone'].nil?
        @phones_map.push(map_to_service_phones(row, 'S1'))
      end
      $i = 2
      4.times.each do |n|
        location_key = 'L' + $i.to_s
        service_key = 'S' + $i.to_s
        if !row[location_key + 'LocName'].nil?
          @locations_map.push(map_to_locations(row, location_key))
          @addresses_map.push(map_to_addresses(row, location_key))
          if !row[location_key + 'Phone'].nil?
            @phones_map.push(map_to_location_phones(row, location_key))
          end
        end
        if !row[service_key + 'ServiceName'].nil?
          @services_map.push(map_to_services(row, service_key))
          if !row[service_key + 'Name'].nil?
            @contacts_map.push(map_to_service_contacts(row, service_key))
          end
          if !row[service_key + 'Phone'].nil?
            @phones_map.push(map_to_service_phones(row, service_key))
          end
        end
        $i += 1
      end
    end
    create_csvs()
  end

  def create_csvs()
    CSV.open("/tmp/ohana-api/data/organizations.csv", "wb") do |csv|
      csv << @orgs_map.first.keys
      @orgs_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/tmp/ohana-api/data/locations.csv", "wb") do |csv|
      csv << @locations_map.first.keys
      @locations_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/tmp/ohana-api/data/addresses.csv", "wb") do |csv|
      csv << @addresses_map.first.keys
      @addresses_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/tmp/ohana-api/data/mail_addresses.csv", "wb") do |csv|
      csv << @mail_addresses_map.first.keys
      @mail_addresses_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/tmp/ohana-api/data/contacts.csv", "wb") do |csv|
      csv << @contacts_map.first.keys
      @contacts_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/tmp/ohana-api/data/phones.csv", "wb") do |csv|
      csv << @phones_map.first.keys
      @phones_map.each do |hash|
        csv << hash.values
      end
    end
    CSV.open("/tmp/ohana-api/data/services.csv", "wb") do |csv|
      csv << @services_map.first.keys
      @services_map.each do |hash|
        csv << hash.values
      end
    end
    puts 'Created CSVs'
  end

  def map_to_organizations(row)
    @org_id += 1
    {
      id:                 @org_id,
      accreditations:     nil,
      alternate_name:     row['B1AltName'],
      date_incorporated:  nil,
      description:        row['B1Description'],
      email:              nil,
      funding_sources:    nil,
      legal_status:       nil,
      licenses:           nil,
      name:               row['B1OrgName'],
      tax_id:             nil,
      tax_status:         nil,
      website:            makeValidUrl(row['B1Website'], 'website'),
      twitter:            makeValidUrl(row['B1Twitter'], 'twitter'),
      facebook:           makeValidUrl(row['B1Facebook'], 'facebook'),
      linkedin:           makeValidUrl(row['B1LinkedIn'], 'linkedin'),
    }
  end

  def map_to_locations(row, key)
    @location_id += 1
    description = row[key + 'LocDesc'] ? row[key + 'LocDesc'] : 'No description provided'
    virtual = row[key + 'Street1'] === 'No physical office' ? true : false;
    {
      id:                 @location_id,
      organization_id:    @org_id,
      accessibility:      nil,
      admin_emails:       nil,
      alternate_name:     nil,
      description:        description,
      email:              nil,
      languages:          nil,
      latitude:           nil,
      longitude:          nil,
      name:               row[key + 'LocName'],
      transportation:     nil,
      virtual:            virtual,
      website:            nil
    }
  end

  def map_to_addresses(row, key)
    @address_id += 1
    {
      id:                 @address_id,
      location_id:        @location_id,
      address_1:          row[key + 'Street1'],
      address_2:          row[key + 'Street2'],
      city:               row[key + 'City'],
      state_province:     row[key + 'State'],
      postal_code:        row[key + 'ZIP'],
      country:            'US'
    }
  end

  def map_to_mail_addresses(row)
    @mail_address_id += 1
    {
      id:                 @mail_address_id,
      location_id:        @location_id,
      attention:          row['B1OrgName'],
      address_1:          row['M1Street1'],
      address_2:          row['M1Street2'],
      city:               row['M1City'],
      state_province:     row['M1State'],
      postal_code:        row['M1ZIP'],
      country:            'US'
    }
  end

  def map_to_main_contacts(row)
    @contact_id += 1
    {
      id:                 @contact_id,
      location_id:        nil,
      organization_id:    @org_id,
      service_id:         nil,
      name:               row['B1OrgContactName'],
      title:              row['B1OrgContactTitle'],
      email:              row['B1Email'],
      department:         nil
    }
  end

  def map_to_service_contacts(row, key)
    @contact_id += 1
    {
      id:                 @contact_id,
      location_id:        nil,
      organization_id:    nil,
      service_id:         @service_id,
      name:               row[key + 'Name'],
      title:              row[key + 'Title'],
      email:              row[key + 'Email'],
      department:         nil
    }
  end

  def map_to_phones(row)
    @phone_id += 1
    phone_number = row['B1Phone'].split(' ext. ')
    {
      id:                 @phone_id,
      contact_id:         @contact_id,
      location_id:        nil,
      organization_id:    @org_id,
      service_id:         nil,
      number:             phone_number[0],
      extension:          phone_number[1] ? phone_number[1] : nil,
      department:         nil,
      number_type:        'voice',
      vanity_number:      nil,
      country_prefix:     nil
    }
  end

  def map_to_location_phones(row, key)
    @phone_id += 1
    phone_number = row[key + 'Phone'].split(' ext. ')
    {
      id:                 @phone_id,
      contact_id:         nil,
      location_id:        @location_id,
      organization_id:    nil,
      service_id:         nil,
      number:             phone_number[0],
      extension:          phone_number[1] ? phone_number[1] : nil,
      department:         nil,
      number_type:        'voice',
      vanity_number:      nil,
      country_prefix:     nil
    }
  end

  def map_to_service_phones(row, key)
    @phone_id += 1
    phone_number = row[key + 'Phone'].split(' ext. ')
    {
      id:                 @phone_id,
      contact_id:         @contact_id,
      location_id:        nil,
      organization_id:    nil,
      service_id:         @service_id,
      number:             phone_number[0],
      extension:          phone_number[1] ? phone_number[1] : nil,
      department:         nil,
      number_type:        'voice',
      vanity_number:      nil,
      country_prefix:     nil
    }
  end

  def map_to_services(row, key)
    @service_id += 1
    description = row[key + 'ServiceDesc'] ? row[key + 'ServiceDesc'] : 'No description provided'
    {
      id:                     @service_id,
      location_id:            @location_id,
      program_id:             nil,
      accepted_payments:      nil,
      alternate_name:         nil,
      description:            description,
      eligibility:            nil,
      email:                  nil,
      fees:                   row[key + 'Fee'],
      funding_sources:        nil,
      application_process:    nil,
      interpretation_sources: nil,
      keywords:               nil,
      languages:              nil,
      name:                   row[key + 'ServiceName'],
      required_documents:     nil,
      service_areas:          nil,
      status:                 'active',
      wait_time:              nil,
      website:                makeValidUrl(row[key + 'URL'], 'website'),
      taxonomy_ids:           assign_taxonomies(row, key).join(',')
    }
  end

  def add_subcategory_id(array, categories_from_db, category_int, column)
   subcats_from_db = categories_from_db['second_level'][category_int]['third_level']
   if (!column.nil?)
     subcats = column.split(', ')
     subcats.each do |subcat|
       subcats_from_db.each do |subcat_from_db|
         if subcat === subcat_from_db["@title"]
           array.push(subcat_from_db["@id"])
         end
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
       if type === "NOT TARGETED"
         array.push("104")
       end
     end
   end
 end

 def add_categories(categories, taxonomy_id_array, row, categories_from_db)
   categories.each do |category|
     case category
     when 'Financial Management'
       taxonomy_id_array.push("101-01")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 0, row['S1FinanceSub'])
     when 'Capital'
       taxonomy_id_array.push("101-02")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 1, row['S1CapitalSub'])
     when 'Legal Services'
       taxonomy_id_array.push("101-03")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 2, row['S1LegalSub'])
     when 'Marketing/Sales'
       taxonomy_id_array.push("101-04")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 3, row['S1MarketingSub'])
     when 'Networking'
       taxonomy_id_array.push("101-05")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 4, row['S1NetworkingSub'])
     when 'Manufacturing/Logistics'
       taxonomy_id_array.push("101-06")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 5, row['S1ManufacturingSub'])
     when 'Procurement'
       taxonomy_id_array.push("101-07")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 6, row['S1ProcurementSub'])
     when 'Planning/Management'
       taxonomy_id_array.push("101-08")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 7, row['S1PlanningSub'])
     when 'R&D/Commercialization'
       taxonomy_id_array.push("101-09")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 8, row['S1RDSub'])
     when 'Regulatory Compliance'
       taxonomy_id_array.push("101-10")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 9, row['S1RegulatorySub'])
     when 'Physical Space'
       taxonomy_id_array.push("101-11")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 10, row['S1SpaceSub'])
     when 'Mentoring/Counseling'
       taxonomy_id_array.push("101-12")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 11, row['S1MentoringSub'])
     when 'Human Resources & Workforce Development'
       taxonomy_id_array.push("101-13")
       add_subcategory_id(taxonomy_id_array, categories_from_db, 12, row['S1HRSub'])
     end
   end
 end

 def assign_taxonomies(row, key)
   taxonomy_id_array = []
   file = File.read("/tmp/ohana-api/data/oe.json")
   json = JSON.parse(file)

   # CATEGORIES
   if !(row[key + 'Categories'].nil?)
     categories_from_db = json['taxonomy']['top_level'][0]
     categories = row[key + 'Categories'].split(',').map(&:strip)
     add_categories(categories, taxonomy_id_array, row, categories_from_db)
   end
   # BUSINESS TYPES
   if !(row[key + 'Type'].nil?)
     business_types_from_db = json['taxonomy']['top_level'][1]
     add_other_tax_id(taxonomy_id_array, business_types_from_db, row[key + 'Type'])
   end
   # BUSINESS STAGES
   if !(row[key + 'Stage'].nil?)
     business_stages_from_db = json['taxonomy']['top_level'][2]
     add_other_tax_id(taxonomy_id_array, business_stages_from_db, row[key + 'Stage'])
   end
   # UNDERSERVED COMMUNITIES
   if !(row[key + 'Community'].nil?)
     communities_from_db = json['taxonomy']['top_level'][3]
     add_other_tax_id(taxonomy_id_array, communities_from_db, row[key + 'Community'])
   end
   # INDUSTRIES
   if !(row[key + 'Industry'].nil?)
     industries_from_db = json['taxonomy']['top_level'][4]
     add_other_tax_id(taxonomy_id_array, industries_from_db, row[key + 'Industry'])
   end
   taxonomy_id_array
 end

 def makeValidUrl(item, type)
   validProtocols = ['http:', 'https:']
   invalidEntries = ['NA', 'n/a', 'N/A']
   if (item)
     if (!validProtocols.include?(item.split('//')[0]))
       if (invalidEntries.include?(item))
         item = nil
       elsif (item.chr === "@")
         item.slice!(0)
         item = 'http://' + type + '.com/' + item
       else
         item = 'http://' + item
       end
     end
   end
   item
 end
end
