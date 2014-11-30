module Taggable
  def shift_and_split_params(params, *fields)
    fields.each do |key|
      params[key] = params[key].shift.split(',')
    end
  end
end
