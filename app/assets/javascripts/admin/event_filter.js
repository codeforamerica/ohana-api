$(document).ready(function() {
  var currentUrl = new URL(window.location.href);
  var queryParam = currentUrl.searchParams.get("filter");
  if (queryParam == 'featured') {
    $('#event_is_featured').val('featured').change();
  }

  $('#event_is_featured').change(function(){
    var searchParams = new URLSearchParams(window.location.search);
    searchParams.set('filter', $('#event_is_featured option:selected').val());
    window.location.search = searchParams.toString();
  });
});
