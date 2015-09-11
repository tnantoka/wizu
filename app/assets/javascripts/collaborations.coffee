$ ->
  $('#collaboration_user_id').select2
    templateResult: (state) ->
      return unless state.id
      $("<span><img src=\"#{$(state.element).data('image')}\" width=\"24\" height=\"24\" /> #{state.text}</span>")

