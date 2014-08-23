class Admin
  class AdminDecorator
    attr_reader :admin

    def initialize(admin)
      @admin = admin
    end

    def locations
      if admin.super_admin?
        Location.pluck(:id, :name, :slug).sort_by(&:second)
      else
        Location.text_search(email: admin.email).pluck(:id, :name, :slug)
      end
    end

    def orgs
      if admin.super_admin?
        Organization.pluck(:id, :name, :slug).sort_by(&:second)
      else
        Organization.joins(:locations).
          where('locations.id IN (?)', locations.map(&:first).flatten).
          uniq.pluck(:id, :name, :slug)
      end
    end

    def allowed_to_access_location?(location)
      locations.flatten.include?(location.id)
    end

    def allowed_to_access_organization?(org)
      orgs.flatten.include?(org.id)
    end
  end
end
