STEP_COUNT = 7
STEP = 12.5
OFFSET = STEP * 2 * (STEP_COUNT + 1)

displayTargetAt = ($target, p) ->
  $target.css {top: p.y - OFFSET, left: p.x - OFFSET}
  $target.show()

setMaskValue = ($mask, big, small) ->
  if big is 3 and small is 5
    big = '½'
    small = ' J'
  else if big >= 7
    big = '1'
    small = ' J'
  else if small is 5
    small = 'h30'
  else
    small = 'h00'

  $mask.find('span.big').html big
  $mask.find('span.small').html small

makeMask = (big, small) ->
  $mask = $ '<div class="mask"><div class="counter"><span class="big"></span><span class="small"></span></div></div>'
  setMaskValue $mask, big, small
  $mask

distance_between = (a, b) ->
  Math.sqrt( Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2) )

initializeTarget = ->
  $target =  $ '<div id="target"></div>'
  $lastTarget = $target
  for i in [1..STEP_COUNT]
    $tmp = $ "<div id=\"circle-#{i}\"></div>"
    $lastTarget.append $tmp
    $lastTarget = $tmp
  $('body').append $target
  $target

$ ->
  $card   = $ 'div.card-display'
  $target = initializeTarget()
  $doc    = $ document
  $btn    = $tile = $mask = reference = distance = null

  $('div.card-display div.card div.actions button'). on 'click', -> 
    $card.hide()

  $('div.tile div.actions button').on 'mousedown', (event) ->
    $btn = $ @
    $tile = $btn.closest('div.tile')
    $mask = makeMask 0, 0
    reference = {x: event.clientX, y: event.clientY}
    displayTargetAt $target, reference
    $tile.prepend $mask

  $doc.on 'mouseup', ->
    if $btn
      $mask.remove()
      $target.hide()

      if $btn.hasClass 'custom'
        $card.show()

      $btn = $tile = $mask = null

  $doc.on 'mousemove', (event) ->
    if $btn
      distance = distance_between reference, {x: event.clientX, y: event.clientY}
      time     = Math.floor(distance / STEP) * 0.5
      small    = (time % 1) * 10
      big      = Math.floor time

      setMaskValue $mask, big, small


