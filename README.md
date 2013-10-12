# Paloma


## What's New?
Paloma (version 3) is almost a complete rewrite of the old versions.

It is now simpler and it also gives more flexibility to the developers. Simplicity and flexibility are achieved by replacing the old callback thingy paradigm by a combination of `Router` and `Controller` components.

All the generator shits are also gone. So developers need not to follow specific folder structure or file name. And since there's no generated files or whatsoever, you can now code in vanilla javascript or **coffescript**! Yay!


## Advantages
* 
* Choose what specific javascript code to run per page.
* Easily make ruby variables available on your javascript files.

## Quick Example

```javascript
```
 
The Rails controller `app/controllers/users_controller.rb`:

```ruby
def UsersController < ApplicationController
    def new
        @user = User.new
        # No special function to call, the javascript callback will be executed automatically
        # just for this specific action.
    end
end
```

That's it! Simply Sexy!

Minimum Requirements
-
* jQuery 1.7 or higher
* Rails 3.1 or higher


Install
-
Without bundler:
```
sudo gem install paloma
```

With bundler, add this to your Gemfile:
```
gem 'paloma'
```

Setup
-
On setup, the `paloma` folder will be generated in `app/assets/javascripts/` containing its required files. Run:
``` 
rails g paloma:setup
```

Require `paloma` in your `application.js`:
```
//= require paloma
```

Basic Directory Structure
-
`paloma` folder contains the javascript callbacks.

* paloma
    * [controller]
        * [action].js
        * [other_action].js
    * [other_controller]
        * [action].js
        * [other_action].js
        * [more_action].js
    * [namespace]
        * [controller]
            * [action].js
     
Generators
-

1. Generate a controller folder containing its required files: 
```
rails g paloma:add [controller]
```
    **Example:**
    ```
    rails g paloma:add users
    ```

    **Generates:**
    * /paloma
        * /users


2. Generate a callback file for a controller's action:
```
rails g paloma:add [controller] [action]
```
    **Example:**
    ```
    rails g paloma:add users new
    ```

    **Generates:**
    * /paloma
        * /users
            * new.js


3. Generate multiple callback files:
```
rails g paloma:add [controller] [action_1] [action_2] ... [action_n]
```
    **Example:**
    ```
    rails g paloma:add users new create edit update
    ```

    **Generates:**
    * /paloma
        * /users
            * new.js
            * create.js
            * edit.js
            * update.js

4. Generate namespaced controller and callbacks:
```
rails g paloma:add [namespace]/[controller] [action_1] [action_2] ... [action_n]
```

    **Example:**
    ```
    rails g paloma:add admin/users new
    ```

    **Generates:**
    * /paloma
        * /admin
            * /users
                * new.js
                
**Notes:** 

* You can directly run `rails g paloma:add [controller] [action]` or `rails g paloma:add [namespace]/[controller] [action]` even the controller folder is not yet 
existing on `paloma` folder. It will be created automatically.

* Controller folder and action javascript files will automatically be created after running `rails g controller` or `rails g scaffold`.

Advanced Callbacks
-
By default Paloma will execute the callback that matches the current controller and action if it finds one.
For instance, if the current response is from the `new` action of the `Users` controller, then Paloma will try to execute `callbacks['users']['new']` if it exists.

You can manipulate callback behavior by using the `js` command before the `render` or `redirect_to` command in your controllers.

1. Preventing the Callback to execute.

    ```ruby
    def destroy
        user = User.find params[:id]
        user.destroy
        
        js false
    end
    ```
    
    `callbacks["controller"]["destroy"]` will not be executed.

2. Using other action's callback from the same controller.

    ```ruby
    def edit
        @user = User.find params[:id]
        js :new
    end
    ```

    This will execute `callback["controllers"]["new"]` instead of `callback["controllers"]["edit"]`.
    
3. Using other action's callback from other controller.

    ```ruby
    def index
        @users = User.all
        js :controller => 'clients', :action => 'index'
    end
    ```

    This will execute `callbacks["clients"]["index"]` instead of `callbacks["controllers"]["index"]`.


4. Using other action's callback from a namespaced controller.

    ```ruby
    class UsersController < ApplicationController
        def destroy
            @user = User.find params[:id]
            @user.destroy
            
            js :controller => 'admin/users', :action => :destroy
        end
    end
    ```

    This will execute `callbacks["admin/users"]["destroy"]` instead of `callbacks["users"]["destroy"]`.


Passing Parameters
-
You can also pass parameters to the callback by passing a `:params` key to `js`. The passed parameters
will be available on the callback by the `params` object.

**Example:**

`users_controller.rb`
```ruby
def destroy
    user = User.find params[:id]
    user.destroy
    
    js :params => {:user_id => params[:id]}
end
```

`/paloma/users/destroy.js`
```javascript
Paloma.callbacks['users']['destroy'] = function(params){
    var id = params['user_id'];
    alert('User ' + id + ' deleted.');
};
```


Default Parameters
-
`params['controller']` - controller name without its namespace.

`params['namespace']` - controller's namespace name.

`params['action']` - controller's action that triggers the filter or callback.

`params['controller_path']` - controller name with its namespace.

`params['callback_controller']` - callback's controller name without its namespace.

`params['callback_namespace']` - callback's namespace name.

`params['callback_action']` - callback's action name.

`params['callback_controller_path']` - callback's controller with its namespace.

## Filters

This is almost similar to Rails controller filters. These are functions executed either `before`, `after`, 
or even `around` (before and after) a Paloma callback is executed.

Filters are defined on `_filters.js` files in Paloma's root folder, namespace folder, or controller folder.

### Syntax

```javascript
filter.as('filter name').before_all().perform(function(params){
    alert("I'm a before filter!");
});

filter.as('another filter').after_all().perform(function(params){
   alert("I'm an after filter"); 
});
```

### Specify Actions To Filter

1. For all actions.
    
    ```javascript
    filter.as('name').before_all()
    filter.as('name').after_all()
    filter.as('name').around_all()
    ```

2. Only for specific action/s.
    
    ```javascript
    filter.as('name').before('new', 'edit', 'update')
    filter.as('name').after('destroy')
    filter.as('name').around('show')
    ```

3. Except for specific action/s.
    
    ```javascript
    filter.as('name').except_before('new')
    filter.as('name').except_after('destroy', 'edit')
    filter.as('name').except_around('show')
    ```

### Filter Inheritance

All `_filters.js` inherit filters defined on the global `_filters.js` file. 
Controller's `_filters.js` will also inherit filters defined on its namespace `_filters.js` if it exists.


### Execution Time

Global filters (on `/paloma/_filters.js`) are executed first, then Namespace filters if any, 
then Controller filters.

Before filters, as you've guessed, are executed before the callback is called. 
The order of execution is based on the order of declaration.
After before filters, around filters are executed then the callback is finally executed.
After filters are called after the callback is executed, then it will execute the around filters again.

### Shared Variable Between Filter and Callback

Automatically, filters has an access to the `params` object passed via the `js` ruby method. 
But you can also make a variable visible both on a filter and a callback using the `_x` object.

**Example:**

on `_filters.js`:
    
```javascript
filter.as('filter name').before('new').perform(function(params){
    _x.sharedVariable = "Sexy Paloma";
});
```
    
on `new.js`:

```javascript
Paloma.callbacks['controller']['new'] = function(params){
    alert(_x.sharedVariable);   // outputs "Sexy Paloma";
});
```

### Skipping Filters

You can skip filters using the `skip_*_filter` or `skip_*_filters` command.
You can also specify which action or actions the filter skip is applicable using `only` or `except` command.

```javascript
filter.skip_before_filter('filter A');  // skip 'filter A' for all actions
filter.skip_after_filters('filter A', 'filter B').only('new', 'edit');  // skip 'filter A' and 'filter B' for 'new' and 'edit' actions.
filter.skip_around_filter('filter A').except('destroy');    // skip 'filter A' for all actions except for 'destroy'.
```

##Locals

Locals are variables or methods which can be made locally available within a controller or a namespace. Locals can also be made available throughout the whole Paloma files (globally).

The motivation of Locals is to organize helper methods and helper variables within a namespace or controller.

1. **Application-wide Locals**

    Defined on `paloma/_locals.js`.
    This contains methods and variables that are intended to be available globally.


2. **Namespace-wide Locals**

    Defiend on `paloma/namespace/_locals.js`.
    This contains methods and variables that are intended to be available on the specific namespace only.


3. **Controller-wide Locals**

    Defined on `paloma/controller/_locals.js` or `paloma/namespace/controller/_locals.js`.
    This contains methods and variables that are intended to be available on the specific controller only.
    

###Creating Locals
Locals can be created using the `locals` object inside `_filters.js` file.

**Example:**

```javascript
locals.helperMethod = function(){
  return "Hello World";
};

locals.helperVariable = "WOW!";
```

###Accessing Locals
Locals can be accessed in your filter and callback files using the `_l` object.

**Example**

```javascript
Paloma.callbacks['users']['new'] = function(params){
    alert("Hello Sexy User");
    
    _l.helperMethod();

    console.log(_l.helperVariable);
};
```

###Accessing Locals From Other Controller/Namespace
Sometimes there is a need to use other's local methods and variables. 
You can achieve this by using the `Paloma.locals` object or its alias `_L`.

**Example**
```javascript
Paloma.callbacks['users']['new'] = function(params){
  _L.otherController.helperMethod();  // accessing local helperMethod() of the otherController
  _L['otherController'].helperVariable;
}
```


###Locals Inheritance
`_locals.js` inherits locals from its parent `_locals.js`, either from namespace or application-wide.
You can also override locals inherited from parents.

**Example**

`paloma/_locals.js` contains:
```javascript
locals.globalMethod = function(){ console.log("I'm from Global"); }
```

`paloma/namespace/_locals.js` contains:
```javascript
locals.namespaceMethod = function(){ console.log("I'm from Namespace"); }
locals.anotherNamespaceMethod = function(){ console.log("I'm also from Namespace"); }
```

`paloma/namespace/controller/_locals.js` contains:
```javascript
locals.controllerMethod = function(){ console.log("I'm from Controller"); }
locals.anotherNamespacedMethod = function(){ console.log("Override!"); }; // Overrides namespace local
```

Since `controller` is under the global `_local.js` and namespace `_local.js` it automatically inherits all their locals.
So you can do something like this inside the controller callback files (or filter files):

```javascript
Paloma.callbacks['namespace/controller']['action'] = function(params){
    _l.controllerMethod();          // outputs "I'm from Controller"
    _l.namespacedMethod();          // outputs "I'm from Namespace"
    _l.globalMethod();              // outputs "I'm from Global"
    _l.anotherNamespacedMethod();   // outputs "Override!"
};
```

Callback Chains
-
Callback chains are created after a redirect action. The chain will continue to increase its length until a render action is detected.

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

A request for `first_action` will lead to 2 redirects until it reaches the `third_action` and renders a result on the browser. When the `third_action` renders its response, Paloma will execute the callbacks for all the 3 actions.

The order of execution will be `[controllers]/first_action` first, then `[controllers]/second_action`, and finally `[controllers]/third_action`.


Gotchas
-
* Callbacks will not be executed if the response is `js`, `json`, `xml` or any other format except `html`.
This will not work: `render "something.js.erb"`

Credits
-
* [Karl Bryan Paragua](http://www.daftcoder.com "Daftcoder.com")
* Bianca Camille Esmero
