$(document).ready(function() {

  if ($(".js-prompt-timer").length > 0) {

    // On story page
    var $timer = $(".js-prompt-timer");
    var seconds_remaining = Math.floor($timer.attr('data-prompt-time'))

    function update_timer_display() {
      let padded_seconds = ("00" + (seconds_remaining % 60)).slice(-2);
      let padded_minutes = ("00" + (Math.floor(seconds_remaining / 60) % 60)).slice(-2);
      let hours = Math.floor(seconds_remaining / 3600);
      $timer.text(hours + "h " + padded_minutes + "m " + padded_seconds + "s");
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
    start_timer();

    function end_timer() {
      $(".story-input").attr("disabled", true);
      $(".story-input").focus();
    }

  }
});
