module EntityPresenter
  def to_array(row, *fields)
    fields.each do |field|
      row[field] =
        if row[field].blank?
          []
        else
          row[field].split(',').map(&:squish)
        end
    end
  end
end
