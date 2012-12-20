Paloma
======
Paloma provides a sexy way to organize javascript files using Rails' asset pipeline. 
It adds the capability to execute specific javascript code after rendering the controller's response.

Advantages
-
* Javascript files are organized per controller just like app/views folder of Rails.
* Javascript file per controller's action.
* The ability to choose what specific javascript code to run on a specific action.

Quick Example
-
The javascript callback file `app/assets/javascripts/paloma/users/new.js`:

```javascript
Paloma.callbacks['users/new'] = function(params){
    // This will only run after executing users/new action
    alert('Hello New Sexy User');
};
```
 
The Rails controller `app/controllers/users_controller.rb`:

```ruby
def UsersController < ApplicationController
    def new
        @user = User.new
        # No special function to call, the javascript callback will be executed automatically
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

Directory Structure
-
`paloma` folder contains the javascript callbacks.

* paloma
    * [controllers]
        * [action].js
        * [other_action].js
    * [other_controllers]
        * [action].js
        * [other_action].js
        * [more_action].js
     
Generators
-
1. Generate a controller folder containing its required files:   
```
rails g paloma:add [controllers]
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
rails g paloma:add [controllers]/[action]
```
    **Example:**
    ```
    rails g paloma:add users/new
    ```

    **Generates:**
    * /paloma
        * /users
            * new.js


**Note:** You can directly run `rails g paloma:add [controllers]/[action]` even the controller folder is not yet 
existing on `paloma` folder. It will be created automatically.


Advanced Callbacks
-
By default Paloma will execute the callback that matches the response's current controller and action if it finds one.
For instance if the current response is from the `new` action of the `Users` controller, then Paloma will execute the callback
named `users/new`.

You can manipulate callback behavior by using the `js_callback` command before the `render` or `redirect_to` command in your controllers.

1. Preventing the Callback to execute.

    ```ruby
    def destroy
        user = User.find params[:id]
        user.destroy
        
        js_callback false
    end
    ```
    
    `[controllers]/destroy` callback will not be executed.

2. Using other action's callback from the same controller.

    ```ruby
    def edit
        @user = User.find params[:id]
        js_callback :new
    end
    ```

    This will execute `[controllers]/new` callback instead of `[controllers]/edit`.
    
3. Using other action's callback from other controller.

    ```ruby
    def index
        @users = User.all
        js_callback :controller => 'clients', :action => 'index'
    end
    ```

    This will execute `clients/index` callback instead of `[controllers]/index`.

Passing Parameters
-
You can also pass parameters to the callback by passing a `:params` key to `js_callback`. The passed parameters
will be available on the callback by the `params` object.

**Example:**

`users_controller.rb`
```ruby
def destroy
    user = User.find params[:id]
    user.destroy
    
    js_callback :params => {:user_id => params[:id]}
end
```

`/paloma/users/destroy.js`
```javascript
Paloma.callbacks['users/destroy'] = function(params){
    var id = params['user_id'];
    alert('User ' + id + ' deleted.');
};
```

Callback Helpers
-
Callback helpers are inside Paloma objects in order to prevent conflicts from different functions and variables.

1. Global

    Helper functions and variables can defined in `paloma/paloma.js` inside the `Paloma.g` object.
    
    **Example:**
    ```javascript
    Paloma.g = {
        helper: function(){
            // do something sexy
        },
        
        helper_variable: 1000
    };
    ```
    
2. Controller's Scope

    Helper functions that you will only use for a certain controller can be defined in `paloma/[controllers]/_local.js` inside
    the `Paloma.[controllers]` object.
    
    **Example:**
    ```javascript
    Paloma.users = {
        local_helper: function(){
            // do something sexy
        },
        
        helper_variable: 1
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
