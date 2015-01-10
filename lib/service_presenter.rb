include EntityPresenter
include ParentAssigner
include CategoryIdCollector

class ServicePresenter < Struct.new(:row)
  def to_service
    service = Service.find_or_initialize_by(id: row[:id].to_i)
    to_array(row, :accepted_payments, :funding_sources, :keywords, :languages,
             :required_documents, :service_areas, :taxonomy_ids)
    service.attributes = row
    assign_categories_to(service, row[:taxonomy_ids])
    assign_parents_for(service, row.except(:taxonomy_ids))
    service
  end

  private

  def assign_categories_to(service, taxonomy_ids)
    service.category_ids = cat_ids(taxonomy_ids)
  end
end
