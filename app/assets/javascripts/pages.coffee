$ ->
  autosize($('#page_content'))
  $('#page_parent_id').select2()
  preview()

preview = _.throttle (e) ->
  return unless $('#page_content').length

  path = '/p/preview'
  params =
    page:
      content: $('#page_content').val()
  $.ajax
    method: 'POST'
    dataType: 'json'
    url: path
    data: params
    success: (data) ->
      $('.js-preview').html(data.html)
    error: (jqXHR, textStatus, errorThrown) ->
      console.error(jqXHR, textStatus, errorThrown)
      errors = jqXHR.responseJSON
      alert(errors.join('\n'))
    complete: ->

, 1000

$(document).on 'keyup', '#page_content', preview
  
