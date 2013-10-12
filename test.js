//
// routes.js
//
// - maps responses from Rails' UsersController to Paloma.Controller.AuthorsController
//
// by default:
//  Rails controller will be mapped to a corresponding Paloma controller with the same name.
//
//
Paloma.Routes.resource('Users', {controller: 'Authors'});
Paloma.Routes.redirect('Users#edit', {to: 'Authors#revise'});

// With namespace
Paloma.Routes.resource('Admin.Users', {controller: 'Authors'});
Paloma.Rotues.resource('Users', {controller: 'Admin.Authors'});



//
// authors_controller.js
//
// - create Paloma.Controller.AuthorsController
// - returns the controller constructor
//
var controller = Paloma.Controller.register('Authors');

controller.before_filter('test', {only: ['edit', 'new']});
controller.after_filter('test', {except: ['edit', 'new']});


controller.prototype.edit = function(){
  this.params['test']; // params from Rails
  // Do something here.
};



var adminAuthorController = Paloma.Controller.register('Admin.Authors');