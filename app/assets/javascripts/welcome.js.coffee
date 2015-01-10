#= require bootstrap/tab


$ ->
  $('#welcomeTabs a').click((e)->
    e.preventDefault()
    $(this).tab('show')
  )
  $('#nounTabs a').click((e)->
    e.preventDefault()
    $(this).tab('show')
  )

  

