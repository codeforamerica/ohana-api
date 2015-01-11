#= require bootstrap/tab
#= require jquery-fileupload/basic
#= require cookie

$ ->
  $('#welcomeTabs a').click((e)->
    e.preventDefault()
    $(this).tab('show')
  )
  $('#nounTabs a').click((e)->
    e.preventDefault()
    $(this).tab('show')
  )

  $('.Feedback .close').on 'click', ->
    $(this).closest('.Feedback').fadeOut('fast', -> $(this).addClass('hide') )

  $('.WelcomeNotice .close').on 'click', ->
    $.cookie 'welcome_notice', true

  configureDisabledEntities = ->
    $("[data-depends-on]").each ->
      entity = $(this).data('depends-on')
      if $("[data-entity='#{entity}']").hasClass('Uploaded')
        $(this).removeClass('Disabled')
      else
        $(this).addClass('Disabled')
  configureDisabledEntities()

  entity = null
  $('.EntityButton').on 'click', ->
    entity = $(this).closest('.Entity').data('entity')
    return if $(this).closest('.Entity').hasClass('Disabled')

    $("[data-entity]").removeClass('current')
    $("[data-entity='#{entity}']").addClass('current')

    $('#EntityUploadFactory').click()

  $('#EntityUploadFactory').fileupload(
    dataType: 'json'
    url: "/welcome/upload"
    formData: {code: CODE}
    limitMultiFileUploads: 1
    sequentialUploads: true
    submit: (e, data)->
      data.formData = {entity: entity, code: CODE}
      true
    progressall: (e, data)->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('.current .progress-bar').css( 'width', progress + '%' )
    done: (e, data)->
      r = data.result


      setTimeout ->
        $('.current .progress-bar').hide().css( 'width', 0 + '%' )



        $('.Feedback').removeClass('hide').show()
        $('.FeedbackMessage').html('')
        if $.isArray(r.message)
          r.message.forEach (msg)->
            $('.FeedbackMessage').append("<p><b>#{r.entity}</b>: #{msg}</p>")
        else
          $('.FeedbackMessage').append("<p><b>#{r.entity}</b>: #{r.message}</p>")

        switch r.status
          when 200
            $('.Feedback').removeClass('alert-danger')
            $('.Feedback').addClass('alert-success')

            $("[data-entity='#{r.entity}']").removeClass('NotUploaded')
            $("[data-entity='#{r.entity}']").addClass('Uploaded')

            configureDisabledEntities()
            
          when 400
            $('.Feedback').removeClass('alert-success')
            $('.Feedback').addClass('alert-danger')

        $("[data-entity]").removeClass('current')

      , 1000

  )

