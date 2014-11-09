class OrganizationPolicy < ApplicationPolicy
  def new?
    user.super_admin?
  end

  class Scope < Scope
    def resolve
      return scope.pluck(:id, :name, :slug) if user.super_admin?
      scope.with_locations(location_ids).pluck(:id, :name, :slug)
    end
  end
end
