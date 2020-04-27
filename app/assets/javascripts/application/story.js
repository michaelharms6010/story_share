$(document).ready(function() {

  if ($(".js-story-timer").length > 0) {

    // On story page
    var $timer = $(".js-story-timer");
    var $timer_start_button = $(".js-story-timer-start");
    var $story_input_overlay = $(".story-input-overlay");
    var $story_input = $(".story-input");
    var seconds_remaining = $timer.attr('data-story-time')
    seconds_remaining = 5;
    console.log( seconds_remaining );

    var $post_story_button = $(".js-story-post-button");
    var $edit_story_button = $(".js-story-edit-button");

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
      $story_input.attr("disabled", true);
      $story_input.focus();
      $edit_story_button.removeClass("hidden");
    }

    $timer_start_button.click(function() {
      $story_input_overlay.hide();
      $story_input.attr("disabled", false);
      $story_input.focus();
      start_timer();
    });

    $edit_story_button.click(function() {
      if (confirm("Add 2 minutes?")) {
        seconds_remaining = 120;
        $story_input.attr("disabled", false);
        $story_input.focus();
        $edit_story_button.addClass("hidden");
        start_timer();
      }
    });

    $post_story_button.click(function() {
      if (seconds_remaining > 0 && !confirm("Submit early?")) {
        return false;
      }
    });


  }





});
