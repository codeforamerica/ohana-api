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
      Organization.with_locations(location_ids_for(locations)).
                  pluck(:id, :name, :slug)
    end

    def programs
      return Program.pluck(:id, :name) if admin.super_admin?
      Program.with_orgs(orgs.map(&:first).flatten).pluck(:id, :name)
    end

    def services
      return Service.pluck(:location_id, :id, :name) if admin.super_admin?
      Service.with_locations(location_ids_for(locations)).
             pluck(:location_id, :id, :name)
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
