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
     
Usage
-
Execute the following command to generate a folder, named as __\<controller_name\>__, which will be the container of all the callbacks that will be used within that controller. Inside this folder, __callbacks.js__ will also be generated.
    
    rails g paloma:add <controller_name>
    
The next command allows the user to create the file __\<action_name\>.js__ under the __\<controller_name\> folder__.

    rails g paloma:add <controller_name>/<action_name>
