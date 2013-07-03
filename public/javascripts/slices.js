(function() {
  var DAY_SIZE, OFFSET, STEP, STEP_COUNT, displayCard, displayTargetAt, distanceBetween, initializeTarget, makeMask, sendBite, setMaskValue, timeParts;

  DAY_SIZE = 7.0;

  STEP_COUNT = 7;

  STEP = 12.5;

  OFFSET = STEP * 2 * (STEP_COUNT + 1);

  displayTargetAt = function($target, p) {
    $target.css({
      top: p.y - OFFSET,
      left: p.x - OFFSET
    });
    return $target.show();
  };

  timeParts = function(time) {
    var big, small;

    small = (time % 1) * 10;
    big = Math.floor(time);
    if (big === 3 && small === 5) {
      big = '½';
      small = ' J';
    } else if (big >= DAY_SIZE) {
      big = '1';
      small = ' J';
    } else if (small === 5) {
      small = 'h30';
    } else {
      small = 'h00';
    }
    return [big, small];
  };

  setMaskValue = function($mask, time) {
    var big, small, _ref;

    _ref = timeParts(time), big = _ref[0], small = _ref[1];
    $mask.find('span.big').html(big);
    return $mask.find('span.small').html(small);
  };

  makeMask = function(time) {
    var $mask;

    $mask = $('<div class="mask"><div class="counter"><span class="big"></span><span class="small"></span></div></div>');
    setMaskValue($mask, time);
    return $mask;
  };

  distanceBetween = function(a, b) {
    return Math.sqrt(Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2));
  };

  initializeTarget = function() {
    var $lastTarget, $target, $tmp, i, _i;

    $target = $('<div id="target"></div>');
    $lastTarget = $target;
    for (i = _i = 1; 1 <= STEP_COUNT ? _i <= STEP_COUNT : _i >= STEP_COUNT; i = 1 <= STEP_COUNT ? ++_i : --_i) {
      $tmp = $("<div id=\"circle-" + i + "\"></div>");
      $lastTarget.append($tmp);
      $lastTarget = $tmp;
    }
    $('body').append($target);
    return $target;
  };

  displayCard = function($card, $tile, time) {
    var $cardTitle, duration, title;

    title = $tile.find('div.title span.project-name').html();
    duration = timeParts(time).join('');
    $cardTitle = $card.find('div.title');
    $cardTitle.find('span.project-name').html(title);
    $cardTitle.find('span.total-duration').html(duration);
    return $card.show();
  };

  sendBite = function(id, params) {
    return $.ajax({
      async: false,
      type: 'POST',
      url: "/slice/" + id + "/bite",
      data: params,
      dataType: 'json'
    }).done(function(data) {
      if (data.success) {
        return window.location.reload();
      }
    });
  };

  $(function() {
    var $btn, $card, $doc, $mask, $target, $tile, distance, reference;

    $card = $('div.card-display');
    $target = initializeTarget();
    $doc = $(document);
    $btn = $tile = $mask = reference = distance = null;
    $('div.tile div.actions button').on('mousedown', function(event) {
      $btn = $(this);
      $tile = $btn.closest('div.tile');
      $mask = makeMask(0.0);
      reference = {
        x: event.clientX,
        y: event.clientY
      };
      displayTargetAt($target, reference);
      return $tile.prepend($mask);
    });
    $doc.on('mouseup', function(event) {
      var size, sliceId, time;

      if ($btn) {
        distance = distanceBetween(reference, {
          x: event.clientX,
          y: event.clientY
        });
        time = Math.floor(distance / STEP) * 0.5;
        size = Math.min(time, DAY_SIZE);
        sliceId = $tile.data('id');
        $mask.remove();
        $target.hide();
        if ($btn.hasClass('custom')) {
          displayCard($card, $tile, time);
          $('div.card-display div.card div.actions button').one('click', function() {
            $card.hide();
            return sendBite(sliceId, {
              size: size,
              occured_at: $card.find('input[name="date"]').val(),
              phonecall: $card.find('input[name="phonecall"]').is(':checked'),
              estimation: $card.find('input[name="estimation"]').is(':checked')
            });
          });
        } else {
          sendBite(sliceId, {
            size: size
          });
        }
        return $btn = $tile = $mask = null;
      }
    });
    return $doc.on('mousemove', function(event) {
      var time;

      if ($btn) {
        distance = distanceBetween(reference, {
          x: event.clientX,
          y: event.clientY
        });
        time = Math.floor(distance / STEP) * 0.5;
        return setMaskValue($mask, time);
      }
    });
  });

}).call(this);
