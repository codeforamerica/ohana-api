include EntityPresenter
include ParentAssigner

class ServicePresenter < Struct.new(:row)
  def to_service
    service = Service.find_or_initialize_by(id: row[:id].to_i)
    to_array(row, :accepted_payments, :funding_sources, :keywords, :languages,
             :required_documents, :service_areas)
    service.attributes = row
    assign_parents_for(service, row)
    service
  end
end
