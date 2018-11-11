class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    return true if user.super_admin?

    scope.flatten.include?(record.id)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  alias new? create?
  alias edit? create?
  alias destroy? create?
  alias update? create?

  private

  def orgs_user_can_access
    @orgs_user_can_access ||= Pundit.policy_scope!(user, Organization)
  end

  def can_access_at_least_one_organization?
    orgs_user_can_access.present?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end

    def location_ids
      Pundit.policy_scope!(user, Location).map(&:first).flatten
    end
  end
end
