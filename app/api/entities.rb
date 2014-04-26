module Entities
  class Location < Grape::Entity
    format_with(:accessibility_text) do |a|
      a.map(&:text)
    end

    expose :id, unless: ->(o, _) { o.id.blank? }
    expose :accessibility, format_with: :accessibility_text, unless: ->(o, _) { o.accessibility.blank? }
    expose :address, using: Address::Entity, unless: ->(o, _) { o.address.blank? }
    expose :admin_emails, unless: ->(o, _) { o.admin_emails.blank? }
    expose :contacts, using: Contact::Entity, unless: ->(o, _) { o.contacts.blank? }
    expose :coordinates, unless: ->(o, _) { o.coordinates.blank? }
    expose :description, unless: ->(o, _) { o.description.blank? }
    expose :emails, unless: ->(o, _) { o.emails.blank? }
    expose :faxes, using: Fax::Entity, unless: ->(o, _) { o.faxes.blank? }
    expose :hours, unless: ->(o, _) { o.hours.blank? }
    expose :languages, unless: ->(o, _) { o.languages.blank? }
    expose :mail_address, using: MailAddress::Entity, unless: ->(o, _) { o.mail_address.blank? }
    expose :name, unless: ->(o, _) { o.name.blank? }
    expose :phones, using: Phone::Entity, unless: ->(o, _) { o.phones.blank? }
    expose :short_desc, unless: ->(o, _) { o.short_desc.blank? }
    expose :slug, unless: ->(o, _) { o.slug.blank? }
    expose :transportation, unless: ->(o, _) { o.transportation.blank? }
    expose :updated_at
    expose :urls, unless: ->(o, _) { o.urls.blank? }
    expose :url, unless: ->(o, _) { o.url.blank? }

    expose :services, using: Service::Entity, unless: ->(o, _) { o.services.blank? }
    expose :organization, using: Organization::Entity
  end
end
