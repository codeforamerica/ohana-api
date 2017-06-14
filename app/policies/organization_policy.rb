class OrganizationPolicy < ApplicationPolicy
  def new?
    user.super_admin?
  end

  class Scope < Scope
    def resolve
      return scope.pluck(:id, :name, :slug).sort_by(&:second) if user.super_admin?
      scope.with_location(location_id).pluck(:id, :name, :slug)
    end
  end
end
