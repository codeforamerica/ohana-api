module Entities
  class Location < Grape::Entity
    format_with(:accessibility_text) do |a|
      a.map(&:text)
    end

    format_with(:kind_text) do |kind|
      kind.text
    end

    expose              :id, :unless => lambda { |o,_| o.id.blank? }
    expose   :accessibility, :format_with => :accessibility_text, :unless => lambda { |o,_| o.accessibility.blank? }
    expose         :address, :using => Address::Entity, :unless => lambda { |o,_| o.address.blank? }
    expose          :admins, :unless => lambda { |o,_| o.admins.blank? }
    expose         :ask_for, :unless => lambda { |o,_| o.ask_for.blank? }
    expose        :contacts, :using => Contact::Entity, :unless => lambda { |o,_| o.contacts.blank? }
    expose     :coordinates, :unless => lambda { |o,_| o.coordinates.blank? }
    expose     :description, :unless => lambda { |o,_| o.description.blank? }
    expose          :emails, :unless => lambda { |o,_| o.emails.blank? }
    expose           :faxes, :unless => lambda { |o,_| o.faxes.blank? }
    expose           :hours, :unless => lambda { |o,_| o.hours.blank? }
    expose            :kind, :format_with => :kind_text, :unless => lambda { |o,_| o.kind.blank? }
    expose       :languages, :unless => lambda { |o,_| o.languages.blank? }
    expose    :mail_address, :using => MailAddress::Entity, :unless => lambda { |o,_| o.mail_address.blank? }
    expose    :market_match, :unless => lambda { |o,_| o.kind != "farmers_markets" }
    expose            :name, :unless => lambda { |o,_| o.name.blank? }
    expose        :payments, :unless => lambda { |o,_| o.payments.blank? }
    expose          :phones, :unless => lambda { |o,_| o.phones.blank? }
    expose        :products, :unless => lambda { |o,_| o.products.blank? }
    expose      :short_desc, :unless => lambda { |o,_| o.short_desc.blank? }
    expose           :slugs, :unless => lambda { |o,_| o.slugs.blank? }
    expose  :transportation, :unless => lambda { |o,_| o.transportation.blank? }
    expose      :updated_at
    expose            :urls, :unless => lambda { |o,_| o.urls.blank? }
    expose             :url, :unless => lambda { |o,_| o.url.blank? }

    expose        :services, :using => Service::Entity, :unless => lambda { |o,_| o.services.blank? }
    expose    :organization, :using => Organization::Entity
  end

end
