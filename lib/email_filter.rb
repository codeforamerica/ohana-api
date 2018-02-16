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
    @model_class.where('? = ANY(admin_emails) OR email = ?', email, email)
  end

  def match_regular_email(email)
    @model_class.where(
      '? = ANY(admin_emails) OR website LIKE ? OR email LIKE ?',
      email, "%#{domain_from(email)}%", "%#{domain_from(email)}%"
    )
  end

  def domain_from(email)
    email.split('@').last
  end
end
