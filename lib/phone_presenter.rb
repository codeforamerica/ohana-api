include ParentAssigner

PhonePresenter = Struct.new(:row) do
  def to_phone
    phone = Phone.find_or_initialize_by(id: row[:id].to_i)
    phone.attributes = row
    assign_parents_for(phone, row)
    phone
  end
end
