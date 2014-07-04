class Admin
  class AdminDecorator
    attr_reader :admin

    def initialize(admin)
      @admin = admin
    end

    def allowed_to_access_location?(location)
      return true if location_admins_match_admin_email?(location) || admin.super_admin?
      if admin_has_generic_email?
        location_emails_match_admin_email?(location)
      else
        location_emails_match_domain?(location) || location_urls_match_domain?(location)
      end
    end

    def domain
      admin.email.split('@').last
    end

    def location_urls_match_domain?(location)
      return false unless location.urls.present?
      location.urls.select { |url| url.include?(domain) }.length > 0
    end

    def location_emails_match_domain?(location)
      return false unless location.emails.present?
      location.emails.select { |email| email.include?(domain) }.length > 0
    end

    def location_emails_match_admin_email?(location)
      return false unless location.emails.present?
      location.emails.include?(admin.email)
    end

    def location_admins_match_admin_email?(location)
      return false unless location.admin_emails.present?
      location.admin_emails.include?(admin.email)
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
