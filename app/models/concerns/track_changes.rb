module TrackChanges
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_admin
    belongs_to :last_changed, class_name: 'Admin'
    serialize :last_changes, Hash

    before_update :track_changes
  end

  def track_changes
    changes = self.changes.reject do |key, value|
      %w(updated_at last_changed_id).include?(key) || value.all?(&:blank?) || value.all? { |x| x == value[0] }
    end

    return if changes.blank?

    self.last_changed = current_admin
    self.last_changes = changes
  end
end
