include ParentAssigner

MailAddressPresenter = Struct.new(:row) do
  def to_mail_address
    mail_address = MailAddress.find_or_initialize_by(id: row[:id].to_i)
    mail_address.attributes = row
    assign_parents_for(mail_address, row)
    mail_address
  end
end
