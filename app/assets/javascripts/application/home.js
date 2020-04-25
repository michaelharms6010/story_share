$(document).ready(function() {

  if ($(".js-home-timer").length > 0) {

    // On story page
    var $timer = $(".js-home-timer");
    var seconds_remaining = $timer.attr('data-prompt-time')

    function update_timer_display() {
      let padded_seconds = ("00" + (seconds_remaining % 60)).slice(-2);
      $timer.text(Math.floor(seconds_remaining / 60) + ":" + padded_seconds);
    }
    update_timer_display();

    function tick_timer() {
      seconds_remaining -= 1;
      update_timer_display();
      if (seconds_remaining > 0) {
        setTimeout(tick_timer, 1000);
      } else {
        end_timer();
      }
    }

    function start_timer() {
      tick_timer();
    }

    function end_timer() {
      $(".story-input").attr("disabled", true);
      $(".story-input").focus();
    }

  }
});
