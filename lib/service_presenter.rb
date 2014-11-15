include EntityPresenter

class ServicePresenter < Struct.new(:row)
  def to_service
    service = Location.find(row[:location_id].to_i).
              services.find_or_initialize_by(id: row[:id].to_i)
    to_array(row, :accepted_payments, :funding_sources, :keywords, :languages,
             :required_documents, :service_areas)
    service.attributes = row
    service
  end
end
