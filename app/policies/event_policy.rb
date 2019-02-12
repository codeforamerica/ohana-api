class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        return scope.with_orgs(org_ids)
                    .pluck(:id, :name, :title, :starting_at, :is_featured)
                    .sort_by{|row| row[3]}
      end
      scope.with_orgs(org_ids).pluck(:id, :title)
    end

    def org_ids
      Pundit.policy_scope!(user, Organization).map(&:first).flatten
    end
  end
end
