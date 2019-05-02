module OrgRecord
    extend ActiveSupport::Concern
    included do
        scope :from_published_orgs, -> { joins(:organization).where('organizations.is_published = true') }
    end
end
