$(document).ready(function() {
  $("#organization_funding_sources,#service_funding_sources,#organization_accreditations,#organization_funding_sources,#organization_licenses").select2({
    tags: [''],
    tokenSeparators: [',']
  });
});
