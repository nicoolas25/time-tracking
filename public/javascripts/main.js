(function() {
  var OFFSET, STEP, STEP_COUNT, displayTargetAt, distance_between, initializeTarget, makeMask, setMaskValue;

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

  setMaskValue = function($mask, big, small) {
    if (big === 3 && small === 5) {
      big = '½';
      small = ' J';
    } else if (big >= 7) {
      big = '1';
      small = ' J';
    } else if (small === 5) {
      small = 'h30';
    } else {
      small = 'h00';
    }
    $mask.find('span.big').html(big);
    return $mask.find('span.small').html(small);
  };

  makeMask = function(big, small) {
    var $mask;

    $mask = $('<div class="mask"><div class="counter"><span class="big"></span><span class="small"></span></div></div>');
    setMaskValue($mask, big, small);
    return $mask;
  };

  distance_between = function(a, b) {
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

  $(function() {
    var $btn, $card, $doc, $mask, $target, $tile, distance, reference;

    $card = $('div.card-display');
    $target = initializeTarget();
    $doc = $(document);
    $btn = $tile = $mask = reference = distance = null;
    $('div.card-display div.card div.actions button').on('click', function() {
      return $card.hide();
    });
    $('div.tile div.actions button').on('mousedown', function(event) {
      $btn = $(this);
      $tile = $btn.closest('div.tile');
      $mask = makeMask(0, 0);
      reference = {
        x: event.clientX,
        y: event.clientY
      };
      displayTargetAt($target, reference);
      return $tile.prepend($mask);
    });
    $doc.on('mouseup', function() {
      if ($btn) {
        $mask.remove();
        $target.hide();
        if ($btn.hasClass('custom')) {
          $card.show();
        }
        return $btn = $tile = $mask = null;
      }
    });
    return $doc.on('mousemove', function(event) {
      var big, small, time;

      if ($btn) {
        distance = distance_between(reference, {
          x: event.clientX,
          y: event.clientY
        });
        time = Math.floor(distance / STEP) * 0.5;
        small = (time % 1) * 10;
        big = Math.floor(time);
        return setMaskValue($mask, big, small);
      }
    });
  });

}).call(this);
