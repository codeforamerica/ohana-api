class ProgramPolicy < ApplicationPolicy
  def new?
    Pundit.policy_scope!(user, Organization).present?
  end

  class Scope < Scope
    def resolve
      return scope.pluck(:id, :name) if user.super_admin?
      scope.with_orgs(org_ids).pluck(:id, :name)
    end

    def org_ids
      Pundit.policy_scope!(user, Organization).map(&:first).flatten
    end
  end
end
