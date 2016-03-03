// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//=# require jquery.turbolinks
//= require jquery_ujs
//=# require turbolinks
//= require paloma
//= require_tree .


// Uncomment if jquery.turbolinks is not used.
// $(document).on('page:load', function(){ Paloma.start(); });


//
//
// Controllers
//
//

var blank = function(){};

Paloma.controller('Main', {
  index: blank,
  otherAction: blank,
  prevent: blank,
  basic_params: blank,
  multiple_calls_1: blank
});


Paloma.controller('OtherMain', {
  show: blank,
  otherAction: blank,
  multiple_calls_2: blank
});

Paloma.controller('Admins/Foos', {
  index: blank,
  otherAction: blank
});

Paloma.controller('NotAdmin/Foos', {
  show: blank,
  otherAction: blank
});


$(document).ready(function(){
  Paloma.start();

  $('#js-ajax-link').on('click', function(e){
    e.preventDefault();

    $.get($(this).prop('href'), function(response){
      $('#js-ajax-response').html(response);
      Paloma.start();
    });
  });
});
