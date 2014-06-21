require 'rails_helper'

describe "GET 'search'" do
  context 'when none of the required parameters are present' do
    before :each do
      create(:location)
      get api_endpoint(path: '/search?zoo=far')
    end

    xit 'returns a 400 bad request status code' do
      expect(response.status).to eq(400)
    end

    xit 'includes an error description' do
      expect(json['description']).
        to eq('Either keyword, location, or language is missing.')
    end
  end

  context 'with valid keyword only' do
    before :each do
      @locations = create_list(:farmers_market_loc, 2)
      get api_endpoint(path: '/search?keyword=market&per_page=1')
    end

    it 'returns a successful status code' do
      expect(response).to be_successful
    end

    it 'is json' do
      expect(response.content_type).to eq('application/json')
    end

    it 'returns locations' do
      expect(json.first['name']).to eq('Belmont Farmers Market')
    end

    it 'is a paginated resource' do
      get api_endpoint(path: '/search?keyword=market&per_page=1&page=2')
      expect(json.length).to eq(1)
      expect(json.first['name']).to eq(@locations.last.name)
    end

    it 'returns an X-Total-Count header' do
      expect(response.status).to eq(200)
      expect(json.length).to eq(1)
      expect(headers['X-Total-Count']).to eq '2'
    end
  end

  context 'with invalid radius' do
    before :each do
      create(:location)
      get api_endpoint(path: '/search?location=94403&radius=ads')
    end

    it 'returns a 400 status code' do
      expect(response.status).to eq(400)
    end

    it 'is json' do
      expect(response.content_type).to eq('application/json')
    end

    it 'includes an error description' do
      expect(json['description']).to eq('Radius must be a Float between 0.1 and 50.')
    end
  end

  context 'with radius too small but within range' do
    it 'returns the farmers market name' do
      create(:farmers_market_loc)
      get api_endpoint(path: '/search?location=la%20honda,%20ca&radius=0.05')
      expect(json.first['name']).to eq('Belmont Farmers Market')
    end
  end

  context 'with radius too big but within range' do
    it 'returns the farmers market name' do
      create(:farmers_market_loc)
      get api_endpoint(path: '/search?location=san%20gregorio,%20ca&radius=50')
      expect(json.first['name']).to eq('Belmont Farmers Market')
    end
  end

  context 'with radius not within range' do
    it 'returns an empty response array' do
      create(:farmers_market_loc)
      get api_endpoint(path: '/search?location=pescadero,%20ca&radius=5')
      expect(json).to eq([])
    end
  end

  context 'with invalid zip' do
    it 'returns no results' do
      create(:farmers_market_loc)
      get api_endpoint(path: '/search?location=00000')
      expect(json.length).to eq 0
    end
  end

  context 'with invalid location' do
    it 'returns no results' do
      create(:farmers_market_loc)
      get api_endpoint(path: '/search?location=94403ab')
      expect(json.length).to eq 0
    end
  end

  context 'with invalid lat_lng parameter' do
    before :each do
      create(:location)
      get api_endpoint(path: '/search?lat_lng=37.6856578-122.4138119')
    end

    it 'returns a 400 status code' do
      expect(response.status).to eq 400
    end

    it 'includes an error description' do
      expect(json['description']).to eq 'lat_lng must be a comma-delimited lat,long pair of floats.'
    end
  end

  context 'with invalid (non-numeric) lat_lng parameter' do
    before :each do
      create(:location)
      get api_endpoint(path: '/search?lat_lng=Apple,Pear')
    end

    it 'returns a 400 status code' do
      expect(response.status).to eq 400
    end

    it 'includes an error description' do
      expect(json['description']).to eq 'lat_lng must be a comma-delimited lat,long pair of floats.'
    end
  end

  context 'when keyword only matches one location' do
    it 'only returns 1 result' do
      create(:location)
      create(:nearby_loc)
      get api_endpoint(path: '/search?keyword=library')
      expect(json.length).to eq(1)
    end
  end

  context "when keyword doesn't match anything" do
    it 'returns no results' do
      create(:location)
      create(:nearby_loc)
      get api_endpoint(path: '/search?keyword=blahab')
      expect(json.length).to eq(0)
    end
  end

  context 'lat_lng search' do
    it 'returns one result' do
      create(:location)
      create(:farmers_market_loc)
      get api_endpoint(path: '/search?lat_lng=37.583939,-122.3715745')
      expect(json.length).to eq 1
    end
  end

  context 'with language parameter' do
    it 'finds organizations that match the language' do
      create(:location)
      create(:nearby_loc)
      get api_endpoint(path: '/search?keyword=library&language=arabic')
      expect(json.first['name']).to eq('Library')
    end
  end

  context 'with singular version of keyword' do
    it "finds the plural occurrence in location's name field" do
      create(:location)
      get api_endpoint(path: '/search?keyword=service')
      expect(json.first['name']).to eq('VRS Services')
    end

    it "finds the plural occurrence in location's description field" do
      create(:location)
      get api_endpoint(path: '/search?keyword=job')
      expect(json.first['description']).to eq('Provides jobs training')
    end

    it 'finds the plural occurrence in organization name field' do
      create(:nearby_loc)
      get api_endpoint(path: '/search?keyword=food%20stamp')
      expect(json.first['organization']['name']).to eq('Food Stamps')
    end

    it "finds the plural occurrence in service's keywords field" do
      create_service
      get api_endpoint(path: '/search?keyword=pantry')
      keywords = json.first['services'].first['keywords']
      expect(keywords).to include 'food pantries'
    end
  end

  context 'with plural version of keyword' do
    it "finds the plural occurrence in location's name field" do
      create(:location)
      get api_endpoint(path: '/search?keyword=services')
      expect(json.first['name']).to eq('VRS Services')
    end

    it "finds the plural occurrence in location's description field" do
      create(:location)
      get api_endpoint(path: '/search?keyword=jobs')
      expect(json.first['description']).to eq('Provides jobs training')
    end

    it 'finds the plural occurrence in organization name field' do
      create(:nearby_loc)
      get api_endpoint(path: '/search?keyword=food%20stamps')
      expect(json.first['organization']['name']).to eq('Food Stamps')
    end

    it "finds the plural occurrence in service's keywords field" do
      create_service
      get api_endpoint(path: '/search?keyword=emergencies')
      keywords = json.first['services'].first['keywords']
      expect(keywords).to include 'emergency'
    end
  end

  context 'when keyword matches category name' do
    before(:each) do
      create(:far_loc)
      create(:farmers_market_loc)
      cat = create(:category)
      create_service
      @service.category_ids = [cat.id]
      @service.save
    end
    it 'boosts location whose services category name matches the query' do
      get api_endpoint(path: '/search?keyword=food')
      expect(headers['X-Total-Count']).to eq '3'
      expect(json.first['name']).to eq 'VRS Services'
    end
  end

  context 'with category parameter' do
    before(:each) do
      create(:nearby_loc)
      create(:farmers_market_loc)
      cat = create(:jobs)
      create_service
      @service.category_ids = [cat.id]
      @service.save
    end

    it 'only returns locations whose category name matches the query' do
      get api_endpoint(path: '/search?category=Jobs')
      expect(headers['X-Total-Count']).to eq '1'
      expect(json.first['name']).to eq('VRS Services')
    end

    it 'only finds exact spelling matches for the category' do
      get api_endpoint(path: '/search?category=jobs')
      expect(headers['X-Total-Count']).to eq '0'
    end

    it 'includes the depth attribute' do
      get api_endpoint(path: '/search?category=Jobs')
      expect(json.first['services'].first['categories'].first['depth']).
        to eq 0
    end
  end

  context 'with category and keyword parameters' do
    before(:each) do
      loc1 = create(:nearby_loc)
      loc2 = create(:farmers_market_loc)
      loc3 = create(:location)

      cat = create(:jobs)
      [loc1, loc2, loc3].each do |loc|
        loc.services.create!(attributes_for(:service))
        service = loc.services.first
        service.category_ids = [cat.id]
        service.save
      end
    end

    it 'returns unique locations when keyword matches the query' do
      get api_endpoint(path: '/search?category=Jobs&keyword=jobs')
      expect(headers['X-Total-Count']).to eq '3'
    end
  end

  context 'with org_name parameter' do
    before(:each) do
      create(:nearby_loc)
      create(:location)
      create(:soup_kitchen)
    end

    it 'returns results when org_name only contains one word that matches' do
      get api_endpoint(path: '/search?org_name=stamps')
      expect(headers['X-Total-Count']).to eq '1'
      expect(json.first['name']).to eq('Library')
    end

    it 'only returns locations whose org name matches all terms' do
      get api_endpoint(path: '/search?org_name=Food+Pantry')
      expect(headers['X-Total-Count']).to eq '1'
      expect(json.first['name']).to eq('Soup Kitchen')
    end
  end

  context 'with keyword and location parameters' do
    before(:each) do
      create(:nearby_loc)
      create(:location)
    end
    it 'only returns locations matching both parameters' do
      get api_endpoint(path: '/search?keyword=books&location=Burlingame')
      expect(headers['X-Total-Count']).to eq '1'
      expect(json.first['name']).to eq('Library')
    end
  end

  context 'when keyword parameter has multiple words' do
    before(:each) do
      create(:nearby_loc)
      create(:location)
    end
    it 'only returns locations matching all words' do
      get api_endpoint(path: '/search?keyword=library%20books%20jobs')
      expect(headers['X-Total-Count']).to eq '1'
      expect(json.first['name']).to eq('Library')
    end
  end

  context 'with domain parameter' do
    it "finds domain name when url contains 'www'" do
      create(:location, urls: ['http://www.smchsa.org'])
      create(:location, emails: ['info@cfa.org'])
      get api_endpoint(path: '/search?domain=smchsa.org')
      expect(headers['X-Total-Count']).to eq '1'
    end

    it 'finds naked domain name' do
      create(:location, urls: ['http://smchsa.com'])
      create(:location, emails: ['hello@cfa.com'])
      get api_endpoint(path: '/search?domain=smchsa.com')
      expect(headers['X-Total-Count']).to eq '1'
    end

    it 'finds long domain name in both url and email' do
      create(:location, urls: ['http://smchsa.org'])
      create(:location, emails: ['info@smchsa.org'])
      get api_endpoint(path: '/search?domain=smchsa.org')
      expect(headers['X-Total-Count']).to eq '2'
    end

    it 'finds domain name when URL contains path' do
      create(:location, urls: ['http://www.smchealth.org/mcah'])
      create(:location, emails: ['org@mcah.org'])
      get api_endpoint(path: '/search?domain=smchealth.org')
      expect(headers['X-Total-Count']).to eq '1'
    end

    it 'finds domain name when URL contains multiple paths' do
      create(:location, urls: ['http://www.smchsa.org/portal/site/planning'])
      create(:location, emails: ['sanmateo@ca.us'])
      get api_endpoint(path: '/search?domain=smchsa.org')
      expect(headers['X-Total-Count']).to eq '1'
    end

    it 'finds domain name when URL contains a dash' do
      create(:location, urls: ['http://www.childsup-connect.ca.gov'])
      create(:location, emails: ['gov@childsup-connect.gov'])
      get api_endpoint(path: '/search?domain=childsup-connect.ca.gov')
      expect(headers['X-Total-Count']).to eq '1'
    end

    it 'finds domain name when URL contains a number' do
      create(:location, urls: ['http://www.prenatalto3.org'])
      create(:location, emails: ['info@rwc2020.org'])
      get api_endpoint(path: '/search?domain=prenatalto3.org')
      expect(headers['X-Total-Count']).to eq '1'
    end

    it "doesn't return results for gmail domain" do
      create(:location, emails: ['info@gmail.com'])
      get api_endpoint(path: '/search?domain=gmail.com')
      expect(headers['X-Total-Count']).to eq '0'
    end

    it "doesn't return results for aol domain" do
      create(:location, emails: ['info@aol.com'])
      get api_endpoint(path: '/search?domain=aol.com')
      expect(headers['X-Total-Count']).to eq '0'
    end

    it "doesn't return results for hotmail domain" do
      create(:location, emails: ['info@hotmail.com'])
      get api_endpoint(path: '/search?domain=hotmail.com')
      expect(headers['X-Total-Count']).to eq '0'
    end

    it "doesn't return results for yahoo domain" do
      create(:location, emails: ['info@yahoo.com'])
      get api_endpoint(path: '/search?domain=yahoo.com')
      expect(headers['X-Total-Count']).to eq '0'
    end

    it "doesn't return results for sbcglobal domain" do
      create(:location, emails: ['info@sbcglobal.net'])
      get api_endpoint(path: '/search?domain=sbcglobal.net')
      expect(headers['X-Total-Count']).to eq '0'
    end

    it 'extracts domain name from parameter' do
      create(:location, emails: ['info@sbcglobal.net'])
      get api_endpoint(path: '/search?domain=info@sbcglobal.net')
      expect(headers['X-Total-Count']).to eq '0'
    end
  end

  context 'when email parameter only contains domain name' do
    it "doesn't return results" do
      create(:location, emails: ['info@gmail.com'])
      get api_endpoint(path: '/search?email=gmail.com')
      expect(headers['X-Total-Count']).to eq '0'
    end
  end

  context 'when email parameter contains full email address' do
    it 'returns locations where either emails or admins fields match' do
      create(:location, emails: ['moncef@smcgov.org'])
      create(:location_with_admin)
      get api_endpoint(path: '/search?email=moncef@smcgov.org')
      expect(headers['X-Total-Count']).to eq '2'
    end
  end

  context 'when email parameter contains full email address' do
    it 'only returns locations where admin email is exact match' do
      create(:location, emails: ['moncef@smcgov.org'])
      create(:location_with_admin)
      get api_endpoint(path: '/search?email=moncef@gmail.com')
      expect(headers['X-Total-Count']).to eq '0'
    end
  end

  describe 'sorting search results' do
    context 'sort when neither keyword nor location is not present' do
      xit 'returns a helpful message about search query requirements' do
        get api_endpoint(path: '/search?sort=name')
        expect(json['description']).
          to eq('Either keyword, location, or language is missing.')
      end
    end

    context 'sort when only location is present' do
      it 'sorts by distance by default' do
        create(:location)
        create(:nearby_loc)
        get api_endpoint(path: '/search?location=1236%20Broadway,%20Burlingame,%20CA%2094010')
        expect(json.first['name']).to eq('VRS Services')
      end
    end
  end

  context 'when location has missing fields' do
    it 'does not include attributes with nil or empty values' do
      create(:loc_with_nil_fields)
      get api_endpoint(path: '/search?keyword=belmont')
      keys = json.first.keys
      %w(faxes fees email).each do |key|
        expect(keys).not_to include(key)
      end
    end
  end
end
