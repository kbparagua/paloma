# Paloma

**This README is for Paloma 4 only.**

**For version 3 README please go [here](https://github.com/kbparagua/paloma/blob/3.0/README.md).**

**For version 2 README please go [here](https://github.com/kbparagua/paloma/blob/2.0/README.md).**


## Paloma 4, why so sudden?
The last major version (v3) of Paloma introduced a major paradigm shift, and it took me a while to realize that some of the major changes introduced are not really that good and needed to be removed.


## What's new?
*(compared to version 2)*
It is now simpler and more flexible. The old callback thingy paradigm is replaced by a `Controller` layer for better abstraction. Generators are also removed, so programmers need not to follow specific directory structure, unlike in the old versions.

Previously, there are generators that create Paloma files, and these files are written in vanilla javascript. Because of that there are some users who are requesting for coffeescript setup. Now since there are no generated files programmers can write their code either by using vanilla javascript or **coffeescript**. Yay!

### Controller
The new paradigm is patterned after Rails Controller, so it is easier to grasp than the old callback paradigm. Basically, you have a Paloma Controller counterpart for every Rails Controller.


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

A Controller constructor is created or accessed (if it already exists), using `Paloma.controller()` method.

```javascript
var ArticlesController = Paloma.controller('Articles');
``` 

It will return the constructor function of your controller.

Note: Using `Paloma.controller` method, you can access the same controller constructor across different files.


### Handling Actions

Every time a request to Paloma is made (A Rails Controller action is executed), an instance of a Paloma controller is created and the method responsible for the request will be invoked.
 
```javascript
var ArticlesController = Paloma.controller('Articles');

ArticlesController.prototype.new = function(){
  // Handle new articles
};

ArticlesController.prototype.edit = function(){
  // Handle edit articles
};
```


## Advanced Usage

You can manipulate what controller/action should Paloma execute by calling `js` method **before** rendering.

1. Changing controller

   ```ruby
   class UsersController < ApplicationController
      def new
         @user = User.new
         js 'Accounts' # will use Accounts controller instead of Users controller
      end
   end
   ```

2. Changing action

   You can use the symbol syntax:
   ```ruby
   def new
      @user = User.new
      js :register # will execute register method instead of new
   end
   ```
   
   Or the string syntax:
   ```ruby
   def new
      @user = User.new
      js '#register'
   end
   ```

3. Changing controller and action.

   ```ruby
   def new
     @user = User.new
     js 'Accounts#register' # will execute Accounts#register instead of Users#new
   end
   ```

4. Changing controller with namespace.

   Paloma supports namespaces using '/' as delimiter.

   ```ruby
   def new
      @user = User.new
      js `Admin/Accounts` # will use Admin/Accounts controller instead of Users controller
   end
   ```
   
   ```ruby
   def new
      @user = User.new
      js 'Admin/Accounts#register' # will execute Admin/Accounts#register instead of Users#new
   end
   ```
   

## Passing Parameters

You can access the parameters on your Paloma Controller using `this.params` object.


1. Parameters only.
 
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

2. Path with parameters.

   ```ruby
   def destroy
      user = User.find params[:id]
      user.destroy
      
      js 'Accounts#delete', :id => user.id
   end
   ```
   
   
## Preventing Paloma Execution

If you want to Paloma not to execute in a specific Rails Controller action you need to pass `false` as the Paloma parameter.

```ruby
def edit
  @user = User.find params[:id]
  js false
end
```


## Controller-wide setup

You can call `js` outside Rails controller actions for global or controller-wide settings.


**Example:**

```ruby
class UsersController < ApplicationController
   js 'Accounts' # use Accounts controller instead of Users for all actions.


   def new
      @user = User.new
   end
   
   def show
      @user = User.find params[:id]
   end
end
```

Like `before_filter` you can also pass `only` and `except` options.


```ruby
class UsersController < ApplicationController

   js 'Admin/Accounts', :except => :destroy # Use Admin/Accounts except for destroy method

end
```


**IMPORTANT NOTE:**
If you are going to pass parameters for Controller-wide settings, put them inside a `:params` hash.

```ruby
class UsersController < ApplicationController
  js 'Accounts', :params => {:x => 1, :y => 2, :z => 3}, :only => :show
end
```

### Overriding Controller-wide setup

If you want to override the controller-wide setup, just call `js` again inside a controller action. From there you can override the controller/action or pass additional parameters.

```ruby
class UsersController < ApplicationController

   js 'Accounts', :params => {:x => 1}
   
   
   def new
      @user = User.new
      js :register, :y => 2 # will execute Accounts#register with params {:x => 1, :y => 2}
   end
end
```

## Gotchas

* Paloma  will not execute if the response is `js`, `json`, `xml` or any other format except `html`.

For example: `render "something.js.erb"`


## Where to put code?

Again, Paloma is now flexible and doesn't force developers to follow specific directory structure.
You have the freedom to create controllers anywhere in your application.

Personally, I prefer having a javascript file for each controller.
