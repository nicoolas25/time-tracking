$ ->
  $card = $ 'div.card-display'
  $card.on 'click', 'div.card div.actions button.cancel', -> $card.hide()
  $('div.tile div.slice-details').on 'click', ->
    $target = $ @
    $tile   = $target.closest 'div.tile'
    id      = $tile.data 'id'
    $.ajax
      url: "/cake/#{id}/slices"
    .done (data) ->
      $card.html data
      $card.show()

