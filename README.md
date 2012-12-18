paloma
======

Javascript Callback Manager for Rails 3


Install
-------
Add the following line to the Gemfile:
    
    gem 'paloma'
     
     
Usage
-----
>*On the first run of either of the two commands mentioned below, the __callbacks__ folder will be generated in __app/assets/javascripts/__. Inside the callbacks folder, __index.js__ will also be created.*

The following are the commands which can be executed in the terminal to generate files needed for the callbacks:
    
    rails g paloma:add <controller_name>
    
>*Execute the command above to generate a folder, named as __\<controller_name\>__ which will be the container of all the callbacks that will be used within that controller. Inside this folder, __callbacks.js__ will also be generated.*

    rails g paloma:add <controller_name>/<action_name>

> *This command allows the user to create the file __\<action_name\>.js__ under the __\<controller_name\> folder__.*


Generated Files
---------------
###index.js
Contains code for requiring all callbacks of all folders and is automatically updated when new folders and callback.js files are created

    # app/assets/javascripts/callbacks/index.js
    
    window.Paloma = {callbacks:{}};
    //= require ./<controller_name>/callbacks

###callbacks.js
Contains code for requiring all callbacks under the same folder <controller_name>

    # app/assets/javascripts/callbacks/<controller_name>/callbacks.js
    
    //= require_tree .

###\<action_name\>.js
Actual code to be executed when callback is called

    # app/assets/javascripts/callbacks/<controller_name>/<action_name>.js
    
    Paloma.callbacks['<controller_name>/<action_name>'] = function(params){
        ...
        //put your code here
        ...
    };
