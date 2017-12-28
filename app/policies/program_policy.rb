class ProgramPolicy < ApplicationPolicy
  delegate :create?, to: :organization_policy

  def new?
    can_access_at_least_one_organization?
  end

  private

  def organization_policy
    @organization_policy ||= Pundit.policy!(user, record.organization)
  end

  class Scope < Scope
    def resolve
      return scope.pluck(:id, :name).sort_by(&:second) if user.super_admin?
      scope.with_orgs(org_ids).pluck(:id, :name)
    end

    def org_ids
      Pundit.policy_scope!(user, Organization).map(&:first).flatten
    end
  end
end
