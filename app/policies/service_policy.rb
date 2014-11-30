class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.pluck(:location_id, :id, :name) if user.super_admin?
      scope.with_locations(location_ids).pluck(:location_id, :id, :name)
    end
  end
end
