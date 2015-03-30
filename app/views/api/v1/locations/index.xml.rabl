collection @locations
cache Digest::MD5.hexdigest(@locations.map(&:cache_key).to_s)

attributes :id, :accessibility, :description, :email, :hours, :kind,
           :languages, :market_match, :name, :payments, :products, :short_desc,
           :transportation, :website

node(:accessibility) { |loc| loc.accessibility.map(&:text) }

node(:kind) { |loc| loc.kind.text }

node(:payments) { |loc| loc.payments if loc.kind == 'farmers_markets' }

node(:products) { |loc| loc.products if loc.kind == 'farmers_markets' }

node(:market_match) { |loc| loc.market_match if loc.kind == 'farmers_markets' }

child(:address) do
  attributes :address_1, :address_2, :city, :state_province, :postal_code
end

child(:mail_address) do
  attributes :attention, :address_1, :address_2, :city, :state_province,
             :postal_code
end

child(:phones) { extends 'phones/phone' }

child(:contacts) { extends 'contacts/contact'}

child(:regular_schedules) { extends 'regular_schedules/regular_schedule' }

child(:holiday_schedules) { extends 'holiday_schedules/holiday_schedule' }

child(:services) do
  attributes :accepted_payments, :alternate_name, :audience, :description,
             :eligibility, :email, :fees, :application_process, :languages, :name,
             :required_documents, :service_areas, :status, :website, :wait_time
  child(:phones) { extends 'phones/phone' }
  child(:contacts) { extends 'contacts/contact'}
  child(:regular_schedules) { extends 'regular_schedules/regular_schedule' }
  child(:holiday_schedules) { extends 'holiday_schedules/holiday_schedule' }
end

child(:organization) do
  attributes :accreditations, :alternate_name, :date_incorporated,
             :description, :email, :legal_status, :licenses, :name, :website
end
