class PagesController
  constructor: ->

  init: ->
    @$content = $('#page_content')
    @edited = false

    @preview()

    autosize(@$content)
    $('#page_parent_id').select2()

    @_initDropzone()
    @_initMousetrap()

  _initDropzone: ->
    $container = $('.js-content-container')
    $container.dropzone
      url: $container.data('attachmentsPath')
      paramName: 'attachment[data]'
      previewsContainer: false
      clickable: '.js-upload'
      params:
        authenticity_token: $('meta[name=csrf-token]').prop('content')
        'attachment[page_id]': $container.data('pageId')
      success: (file, json) =>
        text = if json.is_image
          "[![](#{json.path})](#{json.path})"
        else
          "[#{json.file_name}](#{json.path})"
        @insert(text)
        @preview()

  _initMousetrap: ->
    Mousetrap.bind 'e', ->
      Turbolinks.visit $('.js-edit-page').prop('href')

    Mousetrap.bindGlobal 'mod+s', (e) ->
      if /wiki_title|wiki_content|wiki_slug|page_title|page_content/.test(e.target.id)
        e.preventDefault()
        $('.js-submit-page').click()

  preview: ->
    return unless @$content.length

    path = @$content.data('previewPath')
    params =
      page:
        content: @$content.val()
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

  insert: (text, pos, mode = 'before') ->
    @$content.selection('insert', { text: text, mode: mode })

    evt = document.createEvent('Event')
    evt.initEvent('autosize:update', true, false)
    @$content.get(0).dispatchEvent(evt)

    @preview()

    if pos
      end = @$content.selection('getPos').end + pos
      @$content.selection('setPos', { start: end, end: end })

   edit: ->
     @edited = true

controller = new PagesController()

$ ->
  controller.init()

$(document).on 'keyup', '#page_content', _.throttle ->
  controller.preview()
, 1000

$(document).on 'keyup', '#page_title, #page_content, #wiki_title, #wiki_content, #wiki_slug', ->
  controller.edit()

$(document).on 'click', '.js-insert', (e) ->
  e.preventDefault()
  $elm = $(this)

  text = $elm.data('text')
  pos = $elm.data('pos') || 0

  controller.insert(text.replace(/\\n/g, '\n'), pos)

$(document).on 'click', '.js-upload', (e) ->
  e.preventDefault()

$(window).on 'beforeunload', ->
  if controller.edited
    ' '

