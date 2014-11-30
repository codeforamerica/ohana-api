AutoStripAttributes::Config.setup do
  set_filter reject_blank: false do |value|
    if value.respond_to?(:strip)
      value
    elsif !value.nil?
      value.map(&:squish).reject(&:blank?).uniq
    end
  end
  filters_enabled[:squish] = true
end
