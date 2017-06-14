class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.pluck(:location_id, :id, :name).sort_by(&:third) if user.super_admin?
      scope.with_locations(location_id).pluck(:location_id, :id, :name)
    end
  end
end
