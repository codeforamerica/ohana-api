include EntityPresenter

class ServicePresenter < Struct.new(:row)
  def to_service
    service = Service.find_or_initialize_by(id: row[:id].to_i)
    to_array(row, :accepted_payments, :funding_sources, :keywords, :languages,
             :required_documents, :service_areas)
    service.attributes = row
    assign_parents_for(service)
    service
  end

  private

  def assign_parents_for(service)
    service.location_id = row[:location_id].to_i
    service.program_id = row[:program_id].to_i
  end
end
