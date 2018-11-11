class LocationPolicy < ApplicationPolicy
  def new?
    return true if user.super_admin?
    return super if record.id.present?

    can_access_at_least_one_organization?
  end

  class Scope < Scope
    def resolve
      return scope.pluck(:id, :name, :slug).sort_by(&:second) if user.super_admin?

      scope.with_email(user.email).pluck(:id, :name, :slug)
    end
  end
end
