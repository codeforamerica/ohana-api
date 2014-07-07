class Admin
  class AdminDecorator
    attr_reader :admin

    def initialize(admin)
      @admin = admin
    end

    def allowed_to_access_location?(location)
      return true if location_admin_emails_match_admin_email?(location) || admin.super_admin?
      if admin_has_generic_email?
        location_emails_match_admin_email?(location)
      else
        location_emails_match_domain?(location) || location_urls_match_domain?(location)
      end
    end

    def domain
      admin.email.split('@').last
    end

    %w(urls emails).each do |name|
      define_method "location_#{name}_match_domain?" do |location|
        return false unless location.send(name).present?
        location.send(name).select { |attr| attr.include?(domain) }.present?
      end
    end

    %w(admin_emails emails).each do |name|
      define_method "location_#{name}_match_admin_email?" do |location|
        return false unless location.send(name).present?
        location.send(name).include?(admin.email)
      end
    end

    def admin_has_generic_email?
      generic_domains = SETTINGS[:generic_domains]
      generic_domains.include?(domain)
    end

    def locations
      if admin_has_generic_email?
        Location.text_search(email: admin.email)
      else
        Location.text_search(domain: domain)
      end
    end
  end
end
