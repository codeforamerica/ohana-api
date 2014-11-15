module EntityPresenter
  def to_array(row, *fields)
    fields.each do |field|
      if row[field].blank?
        row[field] = []
      else
        row[field] = row[field].split(',').map(&:squish)
      end
    end
  end
end
