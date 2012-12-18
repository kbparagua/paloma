module Paloma
  #
  # Usage: 
  #   rails g paloma:add <controller_name>
  #     - Generates the following:
  #         - a folder under app/assets/javascripts/callbacks named as <controller_name>
  #         - callbacks.js inside the folder just made
  #     - Updates index.js under the callbacks folder
  #         - adds a line in order to require the callbacks to be made under the recently made folder
  #
  #
  #   rails g paloma:add <controller_name>/<action_name>
  #     - Generates the following:
  #         - <action_name>.js file inside the <controller_name> folder
  #
  #
  # Generated Files:
  #  index.js
  #    - contains code for requiring all callbacks of all folders
  #    - always updated when new folders and callback.js files are created
  #
  #  <controller_name>/callbacks.js
  #    - contains code for requiring all callbacks under the same folder <controller_name> 
  #
  #  <controller_name>/<action_name>.js
  #    - actual code to be executed when callback is called
  #

  class AddGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    
    CALLBACKS = "app/assets/javascripts/callbacks/"
    INDEX = CALLBACKS + 'index.js'
    
    def create_callback_file
      file = file_path.split('/')
      folder = file[0]
      action = file[1]
      
      #index.js on callbacks folder
      has_index = File.exists? INDEX
      copy_file 'index.js', INDEX unless has_index
      
      #callbacks.js per folder(controller) in callbacks
      has_callbacks = File.exists? CALLBACKS + "#{folder}/callbacks.js"
      unless has_callbacks
        copy_file 'callbacks.js', CALLBACKS + "#{folder}/callbacks.js"
        File.open(INDEX, 'a+'){|f| f << "\n//= require ./" + folder + '/callbacks' }
      end
      
      #<action>.js on folder(controller) - code for callback
      has_action = File.exists? CALLBACKS + "#{folder}/#{action}.js"
      unless (action.nil? || has_action)
        create_file CALLBACKS + "#{folder}/#{action}.js"
        File.open(CALLBACKS + "#{folder}/#{action}.js", 'w+') do |f|
          f.write("Paloma.callbacks['#{folder}/#{action}'] = function(params){\n\n};")
        end
      end
    end    
  end
end
