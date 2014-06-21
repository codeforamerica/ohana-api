def create_service
  @location = create(:location)
  @service = @location.services.create!(attributes_for(:service))
  @location.reload
end
