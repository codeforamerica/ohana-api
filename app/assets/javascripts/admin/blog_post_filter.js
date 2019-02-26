$(document).ready(function() {
  var currentUrl = new URL(window.location.href);
  var queryParam = currentUrl.searchParams.get("filter");
  if (queryParam != null) {
    $('#blog_post_category').val(queryParam).change();
  }

  $('#blog_post_category').change(function(){
    var searchParams = new URLSearchParams(window.location.search);
    searchParams.set('filter', $('#blog_post_category option:selected').val());
    window.location.search = searchParams.toString();
  });
});
