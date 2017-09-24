class ContactPolicy < ApplicationPolicy
  delegate :create?, :destroy?, :edit?, :update?, to: :organization_policy

  private

  def organization_policy
    @organization_policy ||= Pundit.policy!(user, record.organization)
  end
end
