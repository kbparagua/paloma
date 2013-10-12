# Paloma


## What's New?
Paloma (version 3) is almost a complete rewrite of the old version.

It is now simpler and it also gives more flexibility to the developers. Simplicity and flexibility are achieved by replacing the old callback thingy paradigm by a combination of `Router` and `Controller` components.

All the generator shits are also gone. So developers need not to follow specific folder structure or file name. And since there's no generated files or whatsoever, you can now code in vanilla javascript or **coffescript**! Yay!

**Basically, Paloma now provides a Controller for your javascript!**

## Advantages
* Choose what specific javascript code to run per page.
* Easily make ruby variables available on your javascript files.


## Quick Example

Paloma controller.

```javascript
var UsersController = Paloma.controller('Users');

// Executes when Rails User#new is rendered.
UsersController.prototype.new = function(){
   alert('Hello Sexy User!' );
};
```
 
The Rails controller `app/controllers/users_controller.rb`:

```ruby
def UsersController < ApplicationController
    def new
      @user = User.new
    end
end
```

That's it! Simply Sexy!

Minimum Requirements
-
* jQuery 1.7 or higher
* Rails 3.1 or higher


## Install

Without bundler:
```
sudo gem install paloma
```

With bundler, add this to your Gemfile:
```
gem 'paloma'
```


Require `paloma` in your `application.js`:
```
//= require paloma
```


## Router

Router is responsible for mapping Rails controller/action to its equivalent Paloma controller/action.

By default all Rails controller/action will be mapped with a Paloma controller/action with the same resource name (controller name without the `Controller` suffix).

Example:
* Response from `UsersController#new` will be mapped to `Users` Paloma controller and execute its `new` method.

### Changing Controller

If you want to use a different Paloma Controller for a specific Rails controller, you can do the following:

```javascript
// Instead of mapping Rails UsersController to Paloma Users
// it will be mapped to AdminUsers.
Paloma.router.resource('Users', {controller: 'AdminUsers'});
```

### Redirecting

You can also redirect an action if you want it to be handled by a different method.

```javascript
// Instead of executing Paloma's `Users#new` it will execute
// `Registrations#signup`.
Paloma.router.redirect('Users#new', {to: 'Registrations#signUp');
```

## Controller

Controller handles responses from Rails. A specific instance of a controller is called by Paloma for every Rails controller/action that is executed.

### Creating Controller

A Controller is created or accessed (if already existing) using:

```javascript
Paloma.controller('ControllerName');
``` 

It returns the constructor of your controller. It is just a normal constructor so you can do your OOP stuff.


### Creating actions

Add instance methods to you Controller constructor to handle actions.

```javascript
var ArticlesController = Paloma.controller('ArticlesController');

ArticlesController.prototype.new = function(){
  // Handle new articles
};


ArticlesController.prototype.edit = function(){
  // Handle edit articles
};
```

## Passing Parameters

You can also pass parameters to Paloma by calling `js` before render in your Rails controller. You can access the parameters on your Paloma controller using `this.params` object.

**Example:**

`users_controller.rb`
```ruby
def destroy
    user = User.find params[:id]
    user.destroy
    
    js :id => user.id
end
```

Paloma controller.

```javascript

var UsersController = Paloma.controller('Users');

UsersController.prototype.destroy = function(){
  alert('User ' + this.params['id'] + ' is deleted.');
};
```

## Preventing Paloma

If you want to prevent Paloma from executing in a certain Rails controller action you can do it by passing `false` to `js` command.

```ruby
def edit
  @user = User.find params[:id]
  js false
end
```

## Execution Chains

Chains are created after a redirect action. The chain will continue to increase its length until a render action is detected.

**Example:**

```ruby
def first_action
    redirect_to second_action_path
end

def second_action
    redirect_to third_action_path
end

def third_action
    render :template => 'third_action_view'
end
```

A request for `first_action` will lead to 2 redirects until it reaches the `third_action` and renders a result on the browser. When the `third_action` renders its response, Paloma will process all the request starting from `first_action` up to `third_action`.


## Gotchas

* Paloma  will not execute if the response is `js`, `json`, `xml` or any other format except `html`.

For example: `render "something.js.erb"`

## Credits

* [Karl Bryan Paragua](http://www.karlparagua.com)
