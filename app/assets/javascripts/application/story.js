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


    // $.fn.autoResize = function(options) {

    //     // Just some abstracted details,
    //     // to make plugin users happy:
    //     var settings = $.extend({
    //         onResize : function(){},
    //         animate : true,
    //         animateDuration : 150,
    //         animateCallback : function(){},
    //         extraSpace : 20,
    //         limit: 1000
    //     }, options);

    //     // Only textarea's auto-resize:
    //     this.filter('textarea').each(function(){

    //             // Get rid of scrollbars and disable WebKit resizing:
    //         var textarea = $(this).css({resize:'none','overflow-y':'hidden'}),

    //             // Cache original height, for use later:
    //             origHeight = textarea.height(),

    //             // Need clone of textarea, hidden off screen:
    //             clone = (function(){

    //                 // Properties which may effect space taken up by chracters:
    //                 var props = ['height','width','lineHeight','textDecoration','letterSpacing'],
    //                     propOb = {};

    //                 // Create object of styles to apply:
    //                 $.each(props, function(i, prop){
    //                     propOb[prop] = textarea.css(prop);
    //                 });

    //                 // Clone the actual textarea removing unique properties
    //                 // and insert before original textarea:
    //                 return textarea.clone().removeAttr('id').removeAttr('name').css({
    //                     position: 'absolute',
    //                     top: 0,
    //                     left: -9999
    //                 }).css(propOb).attr('tabIndex','-1').insertBefore(textarea);

    //             })(),
    //             lastScrollTop = null,
    //             updateSize = function() {

    //                 // Prepare the clone:
    //                 clone.height(0).val($(this).val()).scrollTop(10000);

    //                 // Find the height of text:
    //                 var scrollTop = Math.max(clone.scrollTop(), origHeight) + settings.extraSpace,
    //                     toChange = $(this).add(clone);

    //                 // Don't do anything if scrollTip hasen't changed:
    //                 if (lastScrollTop === scrollTop) { return; }
    //                 lastScrollTop = scrollTop;

    //                 // Check for limit:
    //                 if ( scrollTop >= settings.limit ) {
    //                     $(this).css('overflow-y','');
    //                     return;
    //                 }
    //                 // Fire off callback:
    //                 settings.onResize.call(this);

    //                 // Either animate or directly apply height:
    //                 settings.animate && textarea.css('display') === 'block' ?
    //                     toChange.stop().animate({height:scrollTop}, settings.animateDuration, settings.animateCallback)
    //                     : toChange.height(scrollTop);
    //             };
    //         // Bind namespaced handlers to appropriate events:
    //         textarea
    //             .unbind('.dynSiz')
    //             .bind('keyup.dynSiz', updateSize)
    //             .bind('keydown.dynSiz', updateSize)
    //             .bind('change.dynSiz', updateSize);
    //     });
    //     // Chain:
    //     return this;

    // };
    // $(".story-input").autoResize();



  }





});
