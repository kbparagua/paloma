module Paloma
  #
  # Setup:
  #   rails g paloma:setup
  #     - Generates the following:
  #         - 'paloma' folder under app/assets/javascripts/paloma
  #         - index.js and paloma.js under the 'paloma' folder
  #
  #
  # Usage: 
  #   rails g paloma:add <controller_name>
  #     - Generates the following:
  #         - a folder under app/assets/javascripts/paloma named as <controller_name>
  #         - callbacks.js inside the folder just made
  #     - Updates index.js under the 'paloma' folder
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
  #  paloma.js
  #    - declaration of namespace used in all callbacks
  #
  #  <controller_name>/callbacks.js
  #    - contains code for requiring all callbacks under the same folder <controller_name> 
  #
  #  <controller_name>/<action_name>.js
  #    - actual code to be executed when callback is called
  #
    
  PARENT  = 'app/assets/javascripts/paloma/'
  INDEX = PARENT + 'index.js'
  PALOMA = PARENT + 'paloma.js'
  
  class SetupGenerator < ::Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    def setup_paloma
      #index.js on callbacks folder
      has_index = File.exists? INDEX
      copy_file 'index.js', INDEX unless has_index  
      
      has_paloma = File.exists? PALOMA
      copy_file 'paloma.js', PALOMA unless has_paloma
    end
    
  end
  
  
  class AddGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    
    def create_callback_file
      file = file_path.split('/')
      controller = file[0]
      action = file[1]
      
      callbacks = PARENT + "#{controller}/_callbacks.js"
      templates = "#{Paloma.root}/lib/paloma/templates/"
      local = PARENT + "#{controller}/_local.js"
      action_file = PARENT + "#{controller}/#{action}.js"
      
      #_callbacks.js per folder(controller)
      has_callbacks = File.exists? callbacks
      unless has_callbacks
        Dir.mkdir(PARENT + "#{controller}")
        content = File.read(templates + '_callbacks.js').gsub('controller', "#{controller}")
        File.open(callbacks, 'w'){ |f| f.write(content) }
        File.open(INDEX, 'a+'){ |f| f << "\n//= require ./" + controller + '/_callbacks' }
      end
      
      #_local.js per folder(controller)
      has_local =File.exists? local
      unless has_local
        content = File.read(templates + '_local.js').gsub('controller', "#{controller}")
        File.open(local, 'w'){ |f| f.write(content) }
      end
      
      #<action>.js on folder(controller) - code for callback
      has_action = File.exists? action_file
      unless (action.nil? || has_action)
        content = File.read(templates + 'action.js').gsub('controller/action', "#{controller}/#{action}")
        File.open(action_file, 'w'){ |f| f.write(content) }
      end
    end    
  end
end
