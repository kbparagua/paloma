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

var router = Paloma.router;

router.resource('RailsUser', {controller: 'User'});
router.redirect('RailsUser#revise', {to: 'User#edit'});


var User = Paloma.controller('User');

User.prototype.edit = function(){
  alert('Going to edit User ' + this.params['id']);
};


User.prototype.update = function(){
  alert('Going to update User with name = ' + this.params['name']);
};


Paloma.engine.requests.push({resource: 'RailsUser', action: 'revise', params: {id: 23}});
Paloma.engine.requests.push({resource: 'RailsUser', action: 'revise', params: {id: 99}});

Paloma.engine.requests.push({resource: 'User', action: 'update', params: {name: 'Shibalboy'}});

Paloma.engine.requests.push({resource: 'Article', action: 'new'});

Paloma.engine.start();