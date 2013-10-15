# Paloma

**This README is for Paloma 3 only. 
For version 2 README please go [here](https://github.com/kbparagua/paloma/blob/2.0/README.md).**


## What's New?
Paloma 3 is almost a complete rewrite of the old version.

It is now simpler and more flexible. The old callback thingy paradigm is replaced by a `Router` and `Controller` layer for better abstraction. Generators are also removed, so programmers need not to follow specific directory structure, unlike in the old versions.

Previously, there are generators that create Paloma files, and these files are written in vanilla javascript. Because of that there are some users who are requesting for coffeescript setup. Now since there are no generated files programmers can write their code either by using vanilla javascript or **coffeescript**. Yay!

### Controller and Router
The new paradigm is patterned after Rails Controller and Routes, so it is easier to grasp than the old callback paradigm. Basically, you have a Paloma Controller that is responsible for processing requests made from Rails Controller. While the Router is responsible for telling what Paloma Controller handles what Rails Controller, or what Paloma Controller's action handles what Rails Controller's action. 


### How about Model and View?

It is tempting to convert Paloma 3 to a full-blown MVC or MVP (or whatever) framework. But I've decided to keep it simple and just provide a Controller component as way to execute a specific javascript code per Rails Controller action and give developers freedom on how to handle each action. So you can still have your own Model and View components and just use them in your Paloma Controllers, since a controller is just a middle-man.


## Advantages
* Choose what specific javascript code to run per page.
* Easily make ruby variables available on your javascript files.


## Quick Example

Paloma controller.

```javascript
var UsersController = Paloma.controller('Users');

// Executes when Rails User#new is executed.
UsersController.prototype.new = function(){
   alert('Hello Sexy User!' );
};
```
 
The Rails controller `app/controllers/users_controller.rb`:

```ruby
def UsersController < ApplicationController
    def new
      # a Paloma request will automatically be created.
      @user = User.new
    end
end
```

That's it! Simply Sexy!

## Minimum Requirements
* jQuery 1.7 or higher
* Rails 3.1 or higher


## Install

* Without bundler: `sudo gem install paloma`.
* With bundler, add this to your Gemfile: `gem 'paloma'`
* Require `paloma` in your `application.js`: `//= require paloma`


## Controllers

Controllers are just classes that handle requests made by Rails Controllers. Each Rails Controller's action will be mapped to a specific Paloma Controller's action.


### Creating a Controller

A Controller constructor is created or accessed, if it already exists, using `Paloma.controller()` method.

```javascript
var ArticlesController = Paloma.controller('Articles');
``` 

It will return the constructor function of your controller.


### Handling Actions

Every time a request to Paloma is made (A Rails Controller action is executed), an instance of a Paloma controller is created and a method responsible for the request will be invoked.
 
```javascript
var ArticlesController = Paloma.controller('Articles');

ArticlesController.prototype.new = function(){
  // Handle new articles
};

ArticlesController.prototype.edit = function(){
  // Handle edit articles
};
```

## Passing Parameters

You can also pass parameters to a Paloma Controller by calling `js` **before** render in your Rails controller. You can access the parameters on your Paloma Controller using `this.params` object.

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

## Preventing Paloma Execution

If you want to Paloma not to execute in a specific Rails Controller action you need to pass `false` as the Paloma parameter.

```ruby
def edit
  @user = User.find params[:id]
  js false
end
```

## Execution Chains

A Paloma request is created every time a Rails Controller action is executed. All requests will be recorded until a render action is triggered, and all Paloma requests will be processed following FIFO (First In, First Out) method.

**Example:**

```ruby
def first_action
    # Paloma request will be created
    redirect_to second_action_path
end

def second_action
    # Paloma request will be created
    redirect_to third_action_path
end

def third_action
    # Paloma request will be created
    render :template => 'third_action_view'
end
```

When the `third_action` renders its response, Paloma will process all the request starting from `first_action` up to `third_action`. So, Paloma Controller actions responsible for those 3 Rails actions will be executed.

## Router

Router is responsible for mapping Rails Controller/action to its equivalent Paloma Controller/action.

By default all Rails Controller will be mapped with a Paloma Controller with the same resource name (controller name without the `Controller` suffix).

Example:
* Requests from `UsersController#new` will be mapped to Paloma Controller named `Users` with its `new` method.

If you have no problem with the default behavior, you don't need to write Router stuff in your code.

### Changing Controller

If you want to use a different Paloma Controller for a specific Rails Controller, you can do the following:

```javascript
// Instead of mapping Rails UsersController to Paloma Users Controller
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

## Gotchas

* Paloma  will not execute if the response is `js`, `json`, `xml` or any other format except `html`.

For example: `render "something.js.erb"`


## Where to put code?

Again, Paloma is now flexible and doesn't force developers to follow specific directory structure.
You have the freedom to create controllers and routes anywhere in your application.

Personally, I prefer having a `routes.js` file to contain all the route declarations, and a javascript file for each controller.
