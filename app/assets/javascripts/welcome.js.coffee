#= require jquery-fileupload/basic
#= require cookie
getParameterByName = (name) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  (if results is null then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))

$ ->
  CODE = getParameterByName('code')

  $('.Feedback .close').on 'click', ->
    $(this).closest('.Feedback').fadeOut('fast', -> $(this).addClass('hide') )

  $('.WelcomeNotice .close').on 'click', ->
    $.cookie 'welcome_notice', true

  configureDisabledEntities = ->
    $("[data-depends-on]").each ->
      entity = $(this).data('depends-on')
      entities = entity.split(' and ')
      LogicalAnd = entities.reduce(((acc,ent)=> $("[data-entity='#{ent}']").hasClass('Uploaded') and acc ), true)

      if LogicalAnd
        $(this).removeClass('Disabled')
      else
        $(this).addClass('Disabled')


  configureDisabledEntities()

  entity = null
  $(".Entity[data-entity='location'] .EntityButton").on 'click', ->
    $('#MultiFileEntityUploadFactory').click()


  $(".Entity:not([data-entity='location']) .EntityButton").on 'click', ->
    entity = $(this).closest('.Entity').data('entity')
    return if $(this).closest('.Entity').hasClass('Disabled')

    $("[data-entity]").removeClass('current')
    $("[data-entity='#{entity}']").addClass('current')

    $('#EntityUploadFactory').click()


  postProcessEntity = (r)->
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

  progressall = (e, data)->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('.current .progress-bar').css( 'width', progress + '%' )

  $('#MultiFileEntityUploadFactory').fileupload(
    dataType: 'json'
    url: "/welcome/upload"
    formData: {code: CODE, entity: 'location'}
    limitMultiFileUploads: 2
    limitConcurrentUploads: 2
    sequentialUploads: false
    progressall: progressall
    singleFileUploads: false
    acceptFileTypes: /(\.|\/)(csv)$/i
    add: (e, data)->
      names = []
      data.files.forEach (item)->
        names.push item['name']

      ['addresses.csv','locations.csv'].forEach (item)->
        fname = item.split('.csv')[0]
        cname = fname.charAt(0).toUpperCase() + fname.slice(1) + 'File'

        if $.inArray(item, names) isnt -1
          $(".#{cname}").addClass('text-muted')
        else
          $(".#{cname}").removeClass('text-muted')

      if data.files.length is 2
        # Display the progress bar.
        $("[data-entity]").removeClass('current')
        $("[data-entity='location']").addClass('current')


        # When there are two loaded files in the queue the start uploading
        data.submit()
    always: (e, data)->
      if data.errorThrown
        postProcessEntity({message: data.errorThrown, status: 400, entity: 'Server error'})
    done: (e, data)->
      setTimeout ->
        postProcessEntity(data.result)
      , 1000

  )

  $('#EntityUploadFactory').fileupload(
    dataType: 'json'
    url: "/welcome/upload"
    formData: {code: CODE}
    limitMultiFileUploads: 1
    sequentialUploads: true
    acceptFileTypes: /(\.|\/)(csv)$/i
    submit: (e, data)->
      data.formData = {entity: entity, code: CODE}
      true
    progressall: progressall
    done: (e, data)->
      setTimeout ->
        postProcessEntity(data.result)
      , 1000
  )

