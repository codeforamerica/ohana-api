module Entities
  class Location < Grape::Entity
    format_with(:accessibility_text) do |a|
      a.map(&:text)
    end

    format_with(:kind_text) do |kind|
      kind.text
    end

    format_with(:slug_text) do |slugs|
      slugs.map(&:slug) if slugs.present?
    end

    expose :id, unless: ->(o, _) { o.id.blank? }
    expose :accessibility, format_with: :accessibility_text, unless: ->(o, _) { o.accessibility.blank? }
    expose :address, using: Address::Entity, unless: ->(o, _) { o.address.blank? }
    expose :admin_emails, unless: ->(o, _) { o.admin_emails.blank? }
    expose :ask_for, unless: ->(o, _) { o.ask_for.blank? }
    expose :contacts, using: Contact::Entity, unless: ->(o, _) { o.contacts.blank? }
    expose :coordinates, unless: ->(o, _) { o.coordinates.blank? }
    expose :description, unless: ->(o, _) { o.description.blank? }
    expose :emails, unless: ->(o, _) { o.emails.blank? }
    expose :faxes, using: Fax::Entity, unless: ->(o, _) { o.faxes.blank? }
    expose :hours, unless: ->(o, _) { o.hours.blank? }
    expose :kind, format_with: :kind_text, unless: ->(o, _) { o.kind.blank? }
    expose :languages, unless: ->(o, _) { o.languages.blank? }
    expose :latitude, unless: ->(o, _) { o.latitude.blank? }
    expose :longitude, unless: ->(o, _) { o.longitude.blank? }
    expose :mail_address, using: MailAddress::Entity, unless: ->(o, _) { o.mail_address.blank? }
    expose :market_match, unless: ->(o, _) { o.kind != 'farmers_markets' }
    expose :name, unless: ->(o, _) { o.name.blank? }
    expose :payments, unless: ->(o, _) { o.payments.blank? }
    expose :phones, using: Phone::Entity, unless: ->(o, _) { o.phones.blank? }
    expose :products, unless: ->(o, _) { o.products.blank? }
    expose :short_desc, unless: ->(o, _) { o.short_desc.blank? }
    expose :slug, unless: ->(o, _) { o.slug.blank? }
    expose :slugs, format_with: :slug_text, unless: ->(o, _) { o.slugs.blank? }
    expose :transportation, unless: ->(o, _) { o.transportation.blank? }
    expose :updated_at
    expose :urls, unless: ->(o, _) { o.urls.blank? }
    expose :url, unless: ->(o, _) { o.url.blank? }

    expose :services, using: Service::Entity, unless: ->(o, _) { o.services.blank? }
    expose :organization, using: Organization::Entity
  end
end
