$ ->
  preview()
  autosize($('#page_content'))
  $('#page_parent_id').select2()
  initDropzone()
  initMousetrap()
  $('[data-toggle=tooltip]').tooltip()

initDropzone = ->
  $container = $('.js-content-container')
  $container.dropzone
    url: $container.data('attachmentsPath')
    paramName: 'attachment[data]'
    previewsContainer: false
    clickable: '.js-upload'
    params:
      authenticity_token: $('meta[name=csrf-token]').prop('content')
      'attachment[page_id]': $container.data('pageId')
    success: (file, json) ->
      text = if json.is_image
        "[![](#{json.path})](#{json.path})"
      else
        "[#{json.file_name}](#{json.path})"
      insert(text)
      preview()

initMousetrap = ->
  Mousetrap.bind 'e', ->
    Turbolinks.visit $('.js-edit-page').prop('href')

  Mousetrap.bindGlobal 'mod+s', (e) ->
    if /wiki_title|wiki_content|wiki_slug|page_title|page_content/.test(e.target.id)
      console.log('hoge', )
      e.preventDefault()
      $('.js-submit-page').click()

preview = (e) ->
  $content = $('#page_content')
  return unless $content.length

  path = $content.data('previewPath')
  params =
    page:
      content: $content.val()
  $.ajax
    method: 'POST'
    dataType: 'json'
    url: path
    data: params
    success: (data) ->
      $('.js-preview').html(data.html)
    error: (jqXHR, textStatus, errorThrown) ->
      console.error(jqXHR, textStatus, errorThrown)
      alert(errorThrown)

insert = (text, mode = 'before') ->
  $content = $('#page_content')
  $content
    .selection('insert', { text: text, mode: mode })

  evt = document.createEvent('Event')
  evt.initEvent('autosize:update', true, false)
  $content.get(0).dispatchEvent(evt)

  preview()

$(document).on 'keyup', '#page_content', _.throttle ->
  preview()
, 1000

$(document).on 'click', '.js-insert', (e) ->
  e.preventDefault()
  $elm = $(this)

  text = $elm.data('text')
  insert(text.replace(/\\n/g, '\n'))

  pos = $elm.data('pos')
  if pos
    $content = $('#page_content')
    end = $content.selection('getPos').end + pos
    $content.selection('setPos', { start: end, end: end })

$(document).on 'click', '.js-upload', (e) ->
  e.preventDefault()

