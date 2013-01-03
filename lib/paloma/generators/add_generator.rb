module Paloma
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
  #  <controller_name>/callbacks.js
  #    - contains code for requiring all callbacks under the same folder <controller_name> 
  #
  #  <controller_name>/<action_name>.js
  #    - actual code to be executed when callback is called
  #
    
  class AddGenerator < ::Rails::Generators::NamedBase
    source_root Paloma.templates
    
    def create_callback_file
      arg = file_path.split(' ')
      @controller_name = arg[0]
      action_name = arg[1]
      
      controller_folder = "#{Paloma.destination}/#{@controller_name}/" 
      callbacks_js = "#{controller_folder}/_callbacks.js"
      local_js = "#{controller_folder}/_local.js"
      action_js = "#{controller_folder}/#{action_name}.js"
        
      Dir.mkdir(controller_folder) unless Dir.exists?(controller_folder)
      
      generate_from_template local_js unless File.exists?(local_js)
      generate_from_template callbacks_js unless File.exists?(callbacks_js)        
      
      # Create a js file for action if there is an action argument
      if action_name.present? && !File.exists?(action_js)
        content = File.read("#{Paloma.templates}/action.js").gsub(
          /controller\/action/, 
          "#{@controller_name}/#{action_name}")
          
        File.open(action_js, 'w'){ |f| f.write(content) }
      end
      
      # Require controller's _callbacks.js to Paloma's main index.js file.
      # Located on "#{Paloma.destination}/index.js" or by default on
      # app/assets/javascripts/paloma/index.js
      File.open(Paloma.index_js, 'a+'){ |f| 
        f << "\n//= require ./#{@controller_name}/_callbacks"
      }
    end
    
    
    private
    
    def generate_from_template destination_filename
      filename = destination_filename.split('/').last
      content = File.read("#{Paloma.templates}/#{filename}").gsub(/controller/, @controller_name)
      File.open(destination_filename, 'w'){ |f| f.write(content) }
    end 
  end
end
