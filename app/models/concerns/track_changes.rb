module TrackChanges
  extend ActiveSupport::Concern

  included do
    attr_reader :current_admin
    belongs_to :last_changed, class_name: 'Admin'
    serialize :last_changes, Hash

    before_update :track_changes
  end

  # We need to reflect through our associations to set current_admin
  # so that we will store it when we change a model using nested
  # attributes. We only do this to children -- that is, not belongs_to
  # associations.
  def current_admin=(admin)
    @current_admin = admin
    self.class.reflect_on_all_associations.each do |assoc|
      case assoc.macro
        when :has_many, :has_and_belongs_to_many
          send(assoc.name).each do |child|
            child.current_admin = admin if child.respond_to?(:current_admin=)
          end
        when :has_one
          child = send(assoc.name)
          child.current_admin = admin if child.respond_to?(:current_admin=)
      end
    end
  end

  private

  def track_changes
    # Reject changes that occur as a result of tracking changes
    # or are not changed.
    changes = self.changes.reject do |key, value|
      %w(updated_at last_changed_id).include?(key) ||
          value.all?(&:blank?) ||
          value.all? { |x| x == value[0] }
    end

    unless changes.blank?
      self.last_changed ||= current_admin
      self.last_changes = changes
    end
  end
end
