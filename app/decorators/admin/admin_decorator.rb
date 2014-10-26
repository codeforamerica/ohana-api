class Admin
  class AdminDecorator
    attr_reader :admin

    def initialize(admin)
      @admin = admin
    end

    def locations
      if admin.super_admin?
        Location.pluck(:id, :name, :slug)
      else
        Location.text_search(email: admin.email).pluck(:id, :name, :slug)
      end
    end

    def orgs
      if admin.super_admin?
        Organization.pluck(:id, :name, :slug)
      else
        Organization.joins(:locations).
          where('locations.id IN (?)', locations.map(&:first).flatten).
          uniq.pluck(:id, :name, :slug)
      end
    end

    def programs
      if admin.super_admin?
        Program.pluck(:id, :name)
      else
        Program.joins(:organization).
          where('organization_id IN (?)', orgs.map(&:first).flatten).
          uniq.pluck(:id, :name)
      end
    end

    def services
      if admin.super_admin?
        Service.pluck(:location_id, :id, :name)
      else
        Service.joins(:location).
          where('location_id IN (?)', locations.map(&:first).flatten).
          uniq.pluck(:location_id, :id, :name)
      end
    end

    def allowed_to_access_location?(location)
      locations.flatten.include?(location.id)
    end

    def allowed_to_access_organization?(org)
      orgs.flatten.include?(org.id)
    end

    def allowed_to_access_program?(program)
      programs.flatten.include?(program.id)
    end
  end
end
