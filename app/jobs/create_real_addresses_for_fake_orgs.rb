require 'csv'

class CreateRealAddressesForFakeOrgs

  def initialize()
    @NE_Lat = 38.79309367009685
    @NE_Lng = -121.16951677656246
    @SE_Lat = 38.32058063517934
    @NW_Lng = -121.77376482343746
    @locations_map = []
  end

  def magic()
    200.times.each do |n|
      lat = random_num(@NE_Lat, @SE_Lat)
      lng = random_num(@NE_Lng, @NW_Lng)
      address = Geocoder.address([lat, lng])
      addressArr = address.split(', ');
      address = {
        street: addressArr[0],
        city: addressArr[1],
        state_zip: addressArr[2],
        country: addressArr[3]
      }
      if (!@locations_map.include?(address))
        @locations_map.push(address)
      end
    end
    send_to_csv()
  end

  def random_num(x, y)
    Random.new.rand(y..x)
  end

  def send_to_csv()
    CSV.open("/tmp/ohana-api/data/real_addresses.csv", "wb") do |csv|
      csv << @locations_map.first.keys
      @locations_map.each do |hash|
        csv << hash.values
      end
    end
  end
end
