class OrganizationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.pluck(:id, :name, :slug).sort_by(&:second) if user.super_admin?

      scope.with_locations(location_ids).pluck(:id, :name, :slug)
    end
  end
end
