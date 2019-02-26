$(document).ready(function() {
  $('#featured').click(function(){
    var eventId = $('#event_id').val();
    $.ajax({
      method: 'PUT',
      url: '/admin/events/' + eventId + '/featured',
      data: { event: { is_featured: $('#featured').is(":checked") }, id: eventId }
    })
    .done(function(response) {})
    .fail(function(xhr, status, error) {
      $('#featured').prop('checked', false);
      $('#modal-window-featured').modal('show');
    });
  });
});
