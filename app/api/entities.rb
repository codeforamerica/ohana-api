module Entities
  class Location < Grape::Entity
    expose              :id, :unless => lambda { |o,_| o.id.blank? }
    expose   :accessibility, :unless => lambda { |o,_| o.accessibility.blank? }
    expose         :ask_for, :unless => lambda { |o,_| o.ask_for.blank? }
    expose     :coordinates, :unless => lambda { |o,_| o.coordinates.blank? }
    expose     :description, :unless => lambda { |o,_| o.description.blank? }
    expose          :emails, :unless => lambda { |o,_| o.emails.blank? }
    expose           :faxes, :unless => lambda { |o,_| o.faxes.blank? }
    expose           :hours, :unless => lambda { |o,_| o.hours.blank? }
    expose            :kind, :unless => lambda { |o,_| o.kind.blank? }
    expose       :languages, :unless => lambda { |o,_| o.languages.blank? }
    expose            :name, :unless => lambda { |o,_| o.name.blank? }
    expose          :phones, :unless => lambda { |o,_| o.phones.blank? }
    expose      :short_desc, :unless => lambda { |o,_| o.short_desc.blank? }
    expose  :transportation, :unless => lambda { |o,_| o.transportation.blank? }
    expose            :urls, :unless => lambda { |o,_| o.urls.blank? }

    expose         :address, :using => Address::Entity, :unless => lambda { |o,_| o.address.blank? }
    expose    :mail_address, :using => MailAddress::Entity, :unless => lambda { |o,_| o.mail_address.blank? }
    expose        :contacts, :using => Contact::Entity, :unless => lambda { |o,_| o.contacts.blank? }
    expose      :updated_at
    expose    :organization, :using => Organization::Entity
    expose        :services, :using => Service::Entity, :unless => lambda { |o,_| o.services.blank? }
    expose             :url, :unless => lambda { |o,_| o.url.blank? }
    expose :other_locations, :unless => lambda { |o,_| o.other_locations.blank? }
  end

end
