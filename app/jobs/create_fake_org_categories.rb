require 'csv'
require 'json'
require 'net/http'

class CreateFakeOrgCategories

  @@org_id = 0;
  @@services_map = []

  def create_orgs()
    taxonomy_name_array = []
    file = File.read("/tmp/ohana-api/data/oe.json")
    json = JSON.parse(file)

    500.times.each do |n|
      prng = Random.new
      random_num = prng.rand(100)

      categories_list = []
      finance_array = []
      capital_array = []
      procurement_array =[]
      legal_array = []
      manufacturing_array = []
      marketing_array = []
      mentoring_array = []
      networking_array = []
      planning_array = []
      rd_array = []
      regulartory_array = []
      space_array = []
      hr_array = []
      industries_list = []
      communities_list = []

      categories_from_db = json['taxonomy']['top_level'][0]
      if random_num < 15
        categories_list.push('Financial Managment')
        add_subcategory_id(categories_from_db, prng, 0, finance_array)
      end
      if random_num > 10 && random_num < 40
        categories_list.push('Capital')
        add_subcategory_id(categories_from_db, prng, 1, capital_array)
      end
      if random_num > 20 && random_num < 70
        categories_list.push('Legal Services')
        add_subcategory_id(categories_from_db ,prng, 2, legal_array)
      end
      if random_num > 30 && random_num < 80
        categories_list.push('Marketing/Sales')
        add_subcategory_id(categories_from_db ,prng, 3, marketing_array)
      end
      if random_num > 40 && random_num < 60
        categories_list.push('Networking')
        add_subcategory_id(categories_from_db, prng, 4, networking_array)
      end
      if random_num > 50 && random_num < 60
        categories_list.push('Manufacturing/Logistics')
        add_subcategory_id(categories_from_db, prng, 5, manufacturing_array)
      end
      if random_num > 60 && random_num < 70
        categories_list.push('Procurement')
        add_subcategory_id(categories_from_db, prng, 6, procurement_array)
      end
      if random_num > 70 && random_num < 80
        categories_list.push('Planning/Management')
        add_subcategory_id(categories_from_db, prng, 7, planning_array)
      end
      if random_num > 80 && random_num < 100
        categories_list.push('R&D/Commercialization')
        add_subcategory_id(categories_from_db, prng, 8, rd_array)
      end
      if random_num > 90 && random_num < 100
        categories_list.push('Regulatory Compliance')
        add_subcategory_id(categories_from_db, prng, 9, regulartory_array)
      end
      if random_num > 15 && random_num < 35
        categories_list.push('Physical Space')
        add_subcategory_id(categories_from_db, prng, 10, space_array)
      end
      if random_num > 13 && random_num < 50
        categories_list.push('Mentoring/Counseling')
        add_subcategory_id(categories_from_db, prng, 11, mentoring_array)
      end
      if random_num > 3 && random_num < 45
        categories_list.push('Human Resources & Workforce Development')
        add_subcategory_id(categories_from_db, prng, 12, hr_array)
      end
      # INDUSTRIES
      industries_from_db = json['taxonomy']['top_level'][4]
      add_other_tax_id(prng, industries_from_db, industries_list)
      #COMMUNITIES
      communities_from_db = json['taxonomy']['top_level'][3]
      add_other_tax_id(prng, communities_from_db, communities_list)


      @@services_map.push(map_to_categories(
        categories_list,
        finance_array,
        capital_array,
        procurement_array,
        legal_array,
        manufacturing_array,
        marketing_array,
        mentoring_array,
        networking_array,
        planning_array,
        rd_array,
        regulartory_array,
        space_array,
        hr_array,
        industries_list,
        communities_list
      ))
    end
    send_to_csv()
  end

  def add_subcategory_id(categories_from_db, random, category_int, subcat_arr)
    subcats_from_db = categories_from_db['second_level'][category_int]['third_level']
    subcats_from_db.each do |subcat_from_db|
      num = random.rand(1.00)
      if num > 0.66
        subcat_arr.push(subcat_from_db["@title"])
      end
    end
  end

  def add_other_tax_id(random, data_from_db, array)
    data_from_db['second_level'].each do |d|
      num = random.rand(1.00)
      if num > 0.33 && num < 0.66
        array.push(d["@title"])
      end
    end
  end

  def map_to_categories(categories_list,finance_array,capital_array,procurement_array,legal_array,manufacturing_array,marketing_array,mentoring_array,networking_array,planning_array,rd_array,regulartory_array,space_array,hr_array,industries_list,communities_list)
    @@org_id += 1
    {
     org: @@org_id,
     categories_list: categories_list.join(','),
     FinanceSub: finance_array ? finance_array.join(',') : nil,
     CapitalSub: capital_array ? capital_array.join(',') : nil,
     ProcurementSub: procurement_array ? procurement_array.join(',') : nil,
     LegalSub: legal_array ? legal_array.join(',') : nil,
     ManufacturingSub: manufacturing_array ? manufacturing_array.join(',') : nil,
     MarketingSub: marketing_array ? marketing_array.join(',') : nil,
     MentoringSub: mentoring_array ? mentoring_array.join(',') : nil,
     NetworkingSub: networking_array ? networking_array.join(',') : nil,
     PlanningSub: planning_array ? planning_array.join(',') : nil,
     RDSub: rd_array ? rd_array.join(',') : nil,
     RegulatorySub: regulartory_array ? regulartory_array.join(',') : nil,
     SpaceSub: space_array ? space_array.join(',') : nil,
     HRSub: hr_array ? hr_array.join(',') : nil,
     industries_list: industries_list.join(','),
     communities_list: communities_list.join(','),
    }
  end

  def send_to_csv()
    CSV.open("/tmp/data/fake_org_categories.csv", "wb") do |csv|
      csv << @@services_map.first.keys
      @@services_map.each do |hash|
        csv << hash.values
      end
    end
  end
end

if __FILE__ == $0
   x = CreateFakeOrgCategories.new
   x.create_orgs()
end
