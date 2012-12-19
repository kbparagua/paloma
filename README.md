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
The javascript callback file `paloma/users/new.js`:

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
gem paloma
```

Setup
-
On setup, the `paloma` folder will be generated in `app/assets/javascripts/` containing its required files. Run:
``` 
rails g paloma:setup
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

    This will execute `[controller]/new` callback instead of `[controller]/edit`.
    
3. Using other action's callback from other controller.

    ```ruby
    def index
        @users = User.all
        js_callback :controller => 'clients', :action => 'index'
    end
    ```

    This will execute `clients/index` callback instead of `[controller]/index`.

