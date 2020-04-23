$(document).ready(function() {


  if ($(".js-story-timer").length > 0) {

    // On story page
    var $timer = $(".js-story-timer");
    var $timer_start_button = $(".js-story-timer-start");
    var $story_input_overlay = $(".story-input-overlay");
    var $story_input = $(".story-input");
    var seconds_remaining = $timer.attr('data-story-time')
    console.log( seconds_remaining );

    function update_timer_display() {
      let padded_seconds = ("00" + (seconds_remaining % 60)).slice(-2);
      $timer.text(Math.floor(seconds_remaining / 60) + ":" + padded_seconds);
    }
    update_timer_display();

    function tick_timer() {
      seconds_remaining -= 1;
      update_timer_display();
      console.log(seconds_remaining);
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

    $timer_start_button.click(function() {
      $story_input_overlay.hide();
      $(".story-input").attr("disabled", false);
      $(".story-input").focus();
      start_timer();
    });

  }





});
