// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require turbolinks

//ready =(function(){
//    $('#datepicker').datepicker({ dateFormat: 'yy/mm/dd' })});
$(function() {
  $.datepicker.setDefaults( $.datepicker.regional[ "ja" ] );
  $(".datepicker").datepicker();
});
//$(document).ready(ready)
//$(document).on('page:load', ready)

// go toppage
$(document).ready(function(){
  $(".gotop").hide();
  $(window).on("scroll", function(){
    if ($(this).scrollTop() > 100){
      $('.gotop').slideDown("fast");
    }else{
      $('.gotop').slideUp("fast");
    }
    scrollHeight = $(document).height();
    scrollPosition = $(window).height() + $(window).scrollTop();
    footHeight = $("footer").innerHeight();
    if ( scrollHeight - scrollPosition  <= footHeight ){
      $(".gotop").css({
       "position":"absolute",
       "bottom": footHeight
      });
     }else{
       $(".gotop").css({
         "position":"fixed",
         "bottom": "0px"
       });
     }
  });
  $('.gotop a').click(function (){
    $('body,html').animate({
      scrollTop: 0
     }, 500);
    return false;
  });
});
