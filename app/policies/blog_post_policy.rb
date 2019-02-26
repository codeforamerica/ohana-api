class BlogPostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        return scope.includes(:organization)
                    .includes(:taggings)
                    .order(:title)
      end
      scope.includes(:organization)
    end
  end
end
