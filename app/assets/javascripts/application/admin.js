$(document).ready(function() {


  if ($(".js-debug-stats").length > 0) {

    $(".js-debug-stats").text("Window width: " + window.innerWidth);

    if ($(".js-story-timer-start").length > 0) {
      $(".js-story-timer-start").click(function() {
        $(".js-debug-stats").text("TIMER CLICKED");
      })
    }
  }

});