jQuery ->
  $('.edit-entry').on 'click', '.delete_association', (event) ->
    $(this).prevAll('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('.edit-entry').on 'click', '.delete_attribute', (event) ->
    $(this).closest('fieldset').find('input').val('')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('.edit-entry').on 'click', '.add-fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('.edit-entry').on 'click', '.add-array-fields', (event) ->
    time = new Date().getTime()
    $(this).before($(this).data('fields'))
    inputs = $(this).parent().find('input')
    inputs[inputs.length - 1].setAttribute('id', time)
    event.preventDefault()
