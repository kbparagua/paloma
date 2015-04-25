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
//= require jquery.turbolinks
//= require jquery_ujs
//=# require turbolinks
//= require paloma
//= require_tree .


// Uncomment if jquery.turbolinks is not used.
// $(document).on('page:load', function(){
//   Paloma.executeHook();
//   Paloma.engine.start();
// });


//
//
// Controllers
//
//

var Main = Paloma.controller('Main');
Main.prototype.index = function(){};
Main.prototype.otherAction = function(){};
Main.prototype.prevent = function(){};
Main.prototype.basic_params = function(){};


var OtherMain = Paloma.controller('OtherMain');
OtherMain.prototype.show = function(){};
OtherMain.prototype.otherAction = function(){};



var Foos = Paloma.controller('Admin/Foos');
Foos.prototype.index = function(){};
Foos.prototype.otherAction = function(){};


var NotFoos = Paloma.controller('NotAdmin/Foos');
NotFoos.prototype.show = function(){};
NotFoos.prototype.otherAction = function(){};


$(document).ready(function(){
  $('#js-ajax-link').on('click', function(e){
    e.preventDefault();

    $.get($(this).prop('href'), function(response){
      $('#js-ajax-response').html(response);
      Paloma.executeHook();
      Paloma.engine.start();
    });
  });
});
