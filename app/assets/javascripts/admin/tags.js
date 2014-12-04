$(document).ready(function() {
  $("#organization_accreditations,#organization_licenses,#service_keywords").select2({
    tags: [''],
    tokenSeparators: [',']
  });
});
