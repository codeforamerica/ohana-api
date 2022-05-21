module ParentPresenceValidatable
  def self.included(base)
    base.class_eval do
      validate :parent_presence
    end
  end

  private

  def parent_presence
    return if parents.any?(&:present?)

    errors.add(:base, "#{self.class.name.titleize} is missing a parent: #{list_of_parents}")
  end

  def parents
    belongs_to_associations.map { |a| send(a.name) }
  end

  def belongs_to_associations
    @belongs_to_associations ||= self.class.reflect_on_all_associations(:belongs_to)
  end

  def list_of_parents
    belongs_to_associations.map { |a| a.name.to_s.titleize }.join(' or ')
  end
end
