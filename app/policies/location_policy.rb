class LocationPolicy < ApplicationPolicy
  def new?
    Pundit.policy_scope!(user, Organization).present?
  end

  class Scope < Scope
    def resolve
      return scope.pluck(:id, :name, :slug).sort_by(&:second) if user.super_admin?
      scope.with_email(user.email).pluck(:id, :name, :slug)
    end
  end
end
