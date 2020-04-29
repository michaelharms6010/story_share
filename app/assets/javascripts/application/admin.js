$(document).ready(function() {


  if ($(".js-debug-stats").length > 0) {

    $(".js-debug-stats").html("Window width: " + window.innerWidth);

    if ($(".js-story-timer-start").length > 0) {
      $("div").on("click", function() {
        console.log($(this).html())
        $(".js-debug-stats").text($(".js-debug-stats").html() + "</br>" + $(this).html());
      })
    }
  }

});