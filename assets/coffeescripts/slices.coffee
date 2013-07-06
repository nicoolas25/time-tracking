DAY_SIZE = 7.0
STEP_COUNT = 7
STEP = 12.5
OFFSET = STEP * 2 * (STEP_COUNT + 1)

displayTargetAt = ($target, p) ->
  $target.css {top: p.y - OFFSET, left: p.x - OFFSET}
  $target.show()

timeParts = (time) ->
  small = (time % 1) * 10
  big   = Math.floor time

  if big is 3 and small is 5
    big = '½'
    small = ' J'
  else if big >= DAY_SIZE
    big = '1'
    small = ' J'
  else if small is 5
    small = 'h30'
  else
    small = 'h00'

  return [big, small]

setMaskValue = ($mask, time) ->
  [big, small] = timeParts time
  $mask.find('span.big').html big
  $mask.find('span.small').html small

makeMask = (time) ->
  $mask = $ '<div class="mask"><div class="counter"><span class="big"></span><span class="small"></span></div></div>'
  setMaskValue $mask, time
  $mask

distanceBetween = (a, b) ->
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

displayCard = ($card, $tile, time) ->
  title = $tile.find('div.title span.project-name').html()
  duration = timeParts(time).join ''
  $cardTitle = $card.find('div.title')
  $cardTitle.find('span.project-name').html title
  $cardTitle.find('span.total-duration').html duration
  $card.show()

sendBite = (id, params) ->
  $.ajax
    async: false
    type: 'POST'
    url: "/slice/#{id}/bite"
    data: params
    dataType: 'json'
  .done (data) ->
    if data.success
      window.location.reload()

$ ->
  $card   = $ 'div.card-display'
  $target = initializeTarget()
  $doc    = $ document
  $btn    = $tile = $mask = reference = distance = null

  $('div.card-display div.card div.actions button.cancel'). on 'click', ->
    $card.hide()

  $('div.tile div.actions button').on 'mousedown', (event) ->
    $btn = $ @
    $tile = $btn.closest('div.tile')
    $mask = makeMask 0.0
    reference = {x: event.pageX, y: event.pageY}
    displayTargetAt $target, reference
    $tile.prepend $mask

  $doc.on 'mouseup', (event) ->
    if $btn
      distance = distanceBetween reference, {x: event.pageX, y: event.pageY}
      time     = Math.floor(distance / STEP) * 0.5
      size     = Math.min(time, DAY_SIZE)
      sliceId  = $tile.data('id')

      $mask.remove()
      $target.hide()

      if $btn.hasClass 'custom'
        displayCard $card, $tile, time
        $('div.card-display div.card div.actions button.submit'). one 'click', ->
          $card.hide()
          sendBite sliceId,
            size: size
            occured_at: $card.find('input[name="date"]').val()
            phonecall: $card.find('input[name="phonecall"]').is(':checked')
            estimation: $card.find('input[name="estimation"]').is(':checked')
      else
        sendBite sliceId,
          size: size

      $btn = $tile = $mask = null

  $doc.on 'mousemove', (event) ->
    if $btn
      distance = distanceBetween reference, {x: event.pageX, y: event.pageY}
      time     = Math.floor(distance / STEP) * 0.5
      setMaskValue $mask, time


