module ParentAssigner
  private

  def assign_parents_for(record, row)
    foreign_keys_in(row).each do |key|
      next if row[key].nil?
      record[key] = row[key].to_i
    end
  end

  def foreign_keys_in(row)
    row.keys.select { |key| key.to_s == 'id' || key.to_s.include?('_id') }
  end
end
