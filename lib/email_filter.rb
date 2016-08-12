class EmailFilter
  class << self
    delegate :call, to: :new
  end

  def initialize(model_class = Location)
    @model_class = model_class
  end

  def call(email)
    return @model_class.all if email.blank?
    return @model_class.none unless email.include?('@')
    return match_generic_email(email) if SETTINGS[:generic_domains].include?(domain_from(email))
    match_regular_email(email)
  end

  private

  def match_generic_email(email)
    @model_class.where(arel_model[:admin_emails].matches("%#{email}%").
                or(arel_model[:email].eq(email)))
  end

  def match_regular_email(email)
    @model_class.where(arel_model[:admin_emails].matches("%#{email}%").
                or(arel_model[:website].matches("%#{domain_from(email)}%")).
                or(arel_model[:email].matches("%#{domain_from(email)}")))
  end

  def domain_from(email)
    email.split('@').last
  end

  def arel_model
    @model_class.arel_table
  end
end
