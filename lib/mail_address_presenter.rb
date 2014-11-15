class MailAddressPresenter < Struct.new(:row)
  def to_mail_address
    mail_address = MailAddress.find_or_initialize_by(id: row[:id].to_i)
    mail_address.attributes = row
    mail_address.location_id = row[:location_id].to_i
    mail_address
  end
end
