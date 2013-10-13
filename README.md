# Paloma

**This README is for Paloma 3 only. 
For version 2 README please go [here](https://github.com/kbparagua/paloma/blob/2.0/README.md).**


## What's New?
Paloma 3 is almost a complete rewrite of the old version.

It is now simpler and more flexible. The old callback thingy paradigm is replaced by a `Router` and `Controller` layer for better abstraction. Generators are also removed, so programmers need not to follow specific directory structure, unlike in the old versions.

Previously, there are generators that create Paloma files, and these files are written in vanilla javascript. Because of that there are some users who are requesting for coffeescript setup. Now since there are no generated files programmers can write their code either by using vanilla javascript or **coffeescript**. Yay!

### Controller and Router
The new paradigm is pattered after Rails Controller and Routes, so it is easier to grasp than the old callback paradigm. Basically, you have a Paloma Controller that is responsible for processing responses from Rails Controller. While the Router is responsible for telling what Paloma Controller handles what Rails Controller, or what Paloma Controller's action handles what Rails Controller's action. 


### How about Model and View?

It is tempting to convert Paloma 3 to a full-blown MVC or MVP (or whatever) framework. But I've decided to keep it simple and just provide a Controller component as way to catch Rails responses and give developers freedom on how to process those responses. So you can still have your own Model and View components and just use them in your Paloma Controllers.


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
// `Registrations#signUp`.
Paloma.router.redirect('Users#new', {to: 'Registrations#signUp');
```

## Controller

Controller handles responses from Rails. A new controller instance is created by Paloma for every Rails controller/action that is executed.

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


## Where to put code?

Again, Paloma is now flexible and doesn't force developers to follow specific folder structure.
You have the freedom to create controllers and routes anywhere in your javascript code. 

Personally, I prefer having a `routes.js` file to contain all the route declaration, and a javascript file for each controller.
