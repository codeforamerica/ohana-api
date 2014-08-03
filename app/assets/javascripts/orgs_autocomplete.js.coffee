jQuery ->
  $('#location_organization_id').autocomplete
    source: $('#location_organization_id').data('autocomplete-source')
