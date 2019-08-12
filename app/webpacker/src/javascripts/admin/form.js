(function() {
  jQuery(function() {
    $('.edit-entry').on('click', '.delete_association', function(event) {
      $(this).prevAll('input[type=hidden]').val('1');
      $(this).closest('fieldset').hide();
      return event.preventDefault();
    });
    $('.edit-entry').on('click', '.delete_attribute', function(event) {
      $(this).closest('fieldset').find('input').val('');
      $(this).closest('fieldset').hide();
      return event.preventDefault();
    });
    $('.edit-entry').on('click', '.add-fields', function(event) {
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $(this).before($(this).data('fields').replace(regexp, time));
      return event.preventDefault();
    });
    return $('.edit-entry').on('click', '.add-array-fields', function(event) {
      var inputs, time;
      time = new Date().getTime();
      $(this).before($(this).data('fields'));
      inputs = $(this).parent().find('input');
      inputs[inputs.length - 1].setAttribute('id', time);
      return event.preventDefault();
    });
  });

}).call(this);
