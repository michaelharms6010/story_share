$(document).ready(function() {


  if ($(".js-story-timer").length > 0) {

    // On story page
    var $timer = $(".js-story-timer");
    var $timer_start_button = $(".js-story-timer-start");
    var $story_input_overlay = $(".story-input-overlay");
    var $story_input = $(".story-input");
    var seconds_remaining = $timer.attr('data-story-time')
    console.log( seconds_remaining );

    function startTimer() {
    }

    $timer_start_button.click(function() {
      console.log("START TIMER");
      $story_input_overlay.hide();
      $(".story-input").attr("disabled", false);
      $(".story-input").focus();
    });




  }





});
