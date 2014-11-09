class Admin
  class AdminDecorator
    attr_reader :admin

    def initialize(admin)
      @admin = admin
    end

    def locations
      return Location.pluck(:id, :name, :slug) if admin.super_admin?
      Location.with_email(admin.email).pluck(:id, :name, :slug)
    end

    def location_ids_for(locations)
      locations.map(&:first).flatten
    end

    def orgs
      return Organization.pluck(:id, :name, :slug) if admin.super_admin?
      Organization.joins(:locations).
        where('locations.id IN (?)', location_ids_for(locations)).
        uniq.pluck(:id, :name, :slug)
    end

    def programs
      return Program.pluck(:id, :name) if admin.super_admin?
      Program.joins(:organization).
        where('organization_id IN (?)', orgs.map(&:first).flatten).
        uniq.pluck(:id, :name)
    end

    def services
      return Service.pluck(:location_id, :id, :name) if admin.super_admin?
      Service.joins(:location).
        where('location_id IN (?)', location_ids_for(locations)).
        uniq.pluck(:location_id, :id, :name)
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
