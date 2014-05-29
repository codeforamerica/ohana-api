Geocoder.configure(:lookup => :test)

Geocoder::Lookup::Test.add_stub(
  "94403", [
    {
      'latitude'     => 37.5349925,
      'longitude'    => -122.3050823,
      'address'      => 'San Mateo, CA 94403, USA',
      'state'        => 'California',
      'state_code'   => 'CA',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  "la honda, ca", [
    {
      'latitude'     => 37.3190255,
      'longitude'    => -122.274227,
      'address'      => 'La Honda, CA, USA',
      'state'        => 'California',
      'state_code'   => 'CA',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  "san gregorio, ca", [
    {
      'latitude'     => 37.32716509999999,
      'longitude'    => -122.3866404,
      'address'      => 'San Gregorio, CA 94019, USA',
      'state'        => 'California',
      'state_code'   => 'CA',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  "pescadero, ca", [
    {
      'latitude'     => 37.2551636,
      'longitude'    => -122.3830152,
      'address'      => 'Pescadero, CA, USA',
      'state'        => 'California',
      'state_code'   => 'CA',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  "Burlingame", [
    {
      'latitude'     => 37.5778696,
      'longitude'    => -122.34809,
      'address'      => 'Burlingame, CA, USA',
      'state'        => 'California',
      'state_code'   => 'CA',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  "1236 Broadway, Burlingame, CA 94010", [
    {
      'latitude'     => 37.5857936,
      'longitude'    => -122.3653504,
      'address'      => '1236 Broadway, Burlingame, CA 94010',
      'state'        => 'California',
      'state_code'   => 'CA',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  "00000", []
)

Geocoder::Lookup::Test.add_stub(
  "94403ab", []
)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)
