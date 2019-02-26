$(document).ready(function() {
  var currentUrl = new URL(window.location.href);
  var approvalStatusQueryParam = currentUrl.searchParams.get("filter_by_approval_status");
  var publishedQueryParam = currentUrl.searchParams.get("filter_by_published");

  if (approvalStatusQueryParam != null) {
    $('#organization_approval_status').val(approvalStatusQueryParam).change();
  }

  if (publishedQueryParam != null) {
    $('#organization_is_published').val(publishedQueryParam).change();
  }

  $('#organization_approval_status').change(function(){
    var searchParams = new URLSearchParams(window.location.search);
    searchParams.set('filter_by_approval_status', $('#organization_approval_status option:selected').val());
    window.location.search = searchParams.toString();
  });

  $('#organization_is_published').change(function(){
    var searchParams = new URLSearchParams(window.location.search);
    searchParams.set('filter_by_published', $('#organization_is_published option:selected').val());
    window.location.search = searchParams.toString();
  });
});
