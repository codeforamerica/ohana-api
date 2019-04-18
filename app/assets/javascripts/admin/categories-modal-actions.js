$(document).ready(function() {
  categoriesIdsToDelete = [];
  $('.input-wrapper').on('click', '.remove-item', function() {
    categoryId = $(this).attr('data-id');
    if (categoryId != 'new' && categoriesIdsToDelete.indexOf(categoryId) === -1){
      categoriesIdsToDelete.push(categoryId);
    } else {
      categoriesIdsToDelete = categoriesIdsToDelete.filter(function(category) {
        return category !== categoryId
      });
    }
    if (categoryId == 'new') {
      $(this).parent().remove();
    } else if ($(this).parent().hasClass('element-to-delete')) {
      $(this).parent().removeClass('element-to-delete');
    } else {
      $(this).parent().addClass('element-to-delete');
    }
  });

  $('.add-more').click(function() {
    $('.input-wrapper').append(
      '<div class="categories-modal-input">\
        <input class="form-control newer" type="text">\
        <span aria-hidden="" class="glyphicon glyphicon-remove-sign remove-item" data-id="new"></span>\
      </div>'
    );
  });

  $('.save-categories').click(function() {
    newerCategories = [].map.call($('.newer').get(), function(e) { return e.value});
    $.ajax({
      method: 'PUT',
      url: '/admin/blog_post_categories',
      data: { newers: newerCategories, toDelete: categoriesIdsToDelete }
    })
    .done(function(response) {
      $('.element-to-delete').remove();
      $('#modal-window').modal('hide');
    });
  });

  $('body').on('hidden.bs.modal', '.modal', function () {
    window.location.reload();
  });
});
