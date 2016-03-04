#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require_tree .

updateStatus = (checkbox)->
  container = $(checkbox).parents('.field-row')
  if $(checkbox).prop('checked')
    container.children('.status').html("Attending")
  else
    container.children('.status').html("Not Attending")



$(document).on 'ready page:load', ->

  $(document).on 'change', '.attending input[type=checkbox]', ->
    updateStatus($(this))
    $('form.attendees-form').submit()

  for checkbox in $('.attending input[type=checkbox]')
    updateStatus(checkbox)


  $('form.attendees-form').on 'ajax:success', ->
    clearTimeout(window.savedTimeout)

    $('form.attendees-form .saved').addClass('open')

    close = ->
      $('form.attendees-form .saved').removeClass('open')

    window.savedTimeout = setTimeout close, 3000


  $('form.edit_household').on 'ajax:success', ->
    clearTimeout(window.updatedTimeout)

    $('form.edit_household .saved').addClass('open')

    close = ->
      $('form.edit_household .saved').removeClass('open')

    window.updatedTimeout = setTimeout close, 3000
