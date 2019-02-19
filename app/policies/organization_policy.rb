class OrganizationPolicy < ApplicationPolicy
  def new?
    user.super_admin?
  end

  class Scope < Scope
    def resolve
      if user.super_admin?
        return scope.joins('LEFT JOIN users u ON organizations.user_id = u.id')
                    .pluck(
                            :'organizations.id',
                            :'organizations.name',
                            :'organizations.slug',
                            :'u.name',
                            :'organizations.approval_status',
                            :'organizations.is_published'
                          )
                    .sort_by(&:second)
      end
      scope.with_locations(location_ids).pluck(:id, :name, :slug)
    end
  end
end
