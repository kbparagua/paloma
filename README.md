Paloma
======
Paloma provides a sexy way to organize javascript files using Rails' asset pipeline. 
It adds the capability to execute specific javascript code after rendering the controller's response.


Install
-------
Add the following line to the Gemfile:
    
    gem 'paloma'


Setup
-----
On setup, the __paloma__ folder will be generated in __app/assets/javascripts/__. Inside this folder, __paloma.js__ and __index.js__ will also be created.

Execute the following command in the terminal:
    
    rails g paloma:setup
     
     
Usage
-----
Execute the following command to generate a folder, named as __\<controller_name\>__, which will be the container of all the callbacks that will be used within that controller. Inside this folder, __callbacks.js__ will also be generated.
    
    rails g paloma:add <controller_name>
    
The next command allows the user to create the file __\<action_name\>.js__ under the __\<controller_name\> folder__.

    rails g paloma:add <controller_name>/<action_name>


Generated Files
---------------
###paloma.js
Declaration of namespace used in all callbacks

    # app/assets/javascripts/paloma/paloma.js
    
    window.Paloma = {callbacks:{}};

###index.js
Contains code for requiring all callbacks of all folders and is automatically updated when new folders and callback.js files are created

    # app/assets/javascripts/paloma/index.js
    
    //= require ./paloma
    
    //= require ./<controller_name>/callbacks

###callbacks.js
Contains code for requiring all callbacks under the same folder <controller_name>

    # app/assets/javascripts/paloma/<controller_name>/callbacks.js
    
    //= require_tree .

###\<action_name\>.js
Actual code to be executed when callback is called

    # app/assets/javascripts/paloma/<controller_name>/<action_name>.js
    
    Paloma.callbacks['<controller_name>/<action_name>'] = function(params){
        ...
        //put your code here
        ...
    };
