require 'json'

task :load_data => :environment do
  puts "========================================================================="
  puts "Creating Organizations with San Mateo County, CA Data and saving to DB"
  puts "========================================================================="

  file = "data/test.json"

  invalid_records = {}
  invalid_filename_prefix = file.split('.json')[0].split('/')[1]

  puts "Processing #{file}"
  File.open(file).each do |line|
    data_item = JSON.parse(line)
    #data_item.reject! { |k,_| k == "created_at" || k == "updated_at" }
    org = Organization.create!(data_item)

    progs = data_item["progs"]
    progs.each do |program|
      org.programs.create!(program)
      org.save
    end
    db_progs = org.programs # the newly created programs

    # Use .zip to pair each program hash from the json file to the
    # newly-created program.
    # This results in: [ [db_prog1, json_prog1], [db_prog2, json_prog2] ]
    pairs = db_progs.zip(progs)
    pairs.each do |pair|

      locations = pair[1]["locs"]
      if locations.present?
        locations.each do |location|
          pair[0].locations.create!(location)
          # the program needs to be saved again so that the _keywords
          # field gets updated for the mongoid_search gem to do its job
          pair[0].save
        end
      end

      # db_locs = pair[0].locations
      # locs = locations
      # pairs = db_locs.zip(locs)
      # pairs.each do |pair|
      #   address = pair[1]["address"]
      #   mail    = pair[1]["mail_address"]
      #   pair[0].create_address(address) if address.present?
      #   pair[0].create_mail_address(mail) if mail.present?
      # end
    end

      # contacts = pair[1]["leaders"]
      # if contacts.present?
      #   contacts.each do |contact|
      #     pair[0].contacts.create!(contact)
      #   end
      # end

    Organization.all.unset('locs')
    Organization.all.unset('progs')
    Program.all.unset('locs')
    #Program.all.unset('leaders')
  end
  puts "Done loading #{file} into DB"
  puts "Done loading San Mateo County data into DB."
end