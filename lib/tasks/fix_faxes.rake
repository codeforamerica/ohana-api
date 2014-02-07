task :fix_faxes => :environment do
  puts "===> Converting faxes from String to Hash..."

  # When we first converted the data from MARC21 format to JSON,
  # we assumed the faxes field would be an array of Strings, but
  # now we want to make it a Hash so that we can specify both a
  # number and a department for the fax number. Making it a Hash
  # also allows us to add more parameters to the fax number in the
  # future.
  #
  # In order for Elasticsearch to be able to index locations that
  # have faxes as a Hash, we need to convert all the String faxes in the
  # DB to a Hash.
  locations_with_fax = Location.where(:faxes.ne => nil)
  locations_with_fax.each do |location|
    new_faxes = []
    location.faxes.each do |fax|
      new_faxes.push({ :number => fax }) if fax.is_a?(String)
    end
    location.update_attributes!(:faxes => new_faxes) unless new_faxes.empty?
  end
end