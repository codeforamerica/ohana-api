module ParentAssigner
  def assign_parents_for(entity)
    assign_service_for(entity)
    assign_location_for(entity)
    assign_organization_for(entity)
  end

  def assign_service_for(entity)
    entity.service_id = row[:service_id].to_i
  end

  def assign_location_for(entity)
    entity.location_id = row[:location_id].to_i
  end

  def assign_organization_for(entity)
    entity.organization_id = row[:organization_id].to_i
  end
end
