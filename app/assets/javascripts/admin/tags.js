$(document).ready(function() {
  $("#service_funding_sources,#service_keywords,#organization_accreditations,#organization_funding_sources,#organization_licenses").select2({
    tags: [''],
    tokenSeparators: [',']
  });
});
