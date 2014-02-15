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
//= require jquery_ujs
//= require paloma
//= require_tree .


// Will be manipulated by Paloma controllers.
window.called = [];



//
//
// Controllers
//
//
var Main = Paloma.controller('Main');

Main.prototype.index = function(){
  window.called.push('Main#index');
};



var MyFoo = Paloma.controller('MyFoo');

MyFoo.prototype.index = function(){
  window.called.push('MyFoo#index');
};


MyFoo.prototype.show = function(){
  window.called.push('MyFoo#show');
  window.parameter = this.params.parameter;
};


MyFoo.prototype.edit = function(){
  window.called.push('MyFoo#edit');
};



var AnotherFoo = Paloma.controller('AnotherFoo');

AnotherFoo.prototype.build = function(){
  window.called.push('AnotherFoo#build');
};



var Bar = Paloma.controller('Admin/Bar');

Bar.prototype.show = function(){
  window.called.push('Admin/Bar#show');
};





var MultipleNames = Paloma.controller('MultipleNames');

MultipleNames.prototype.index = function(){
  window.called.push('MultipleNames#index')
};