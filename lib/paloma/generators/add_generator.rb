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
      args =  split_arguments(file_path)
      
      namespace_name = args[0]
      namespace_folder = args[1]
      @controller_name = args[2]
      controller_folder = args[3]
      action_name = args[4]
                
      callbacks_js = "#{controller_folder}/_callbacks.js"
      local_js = "#{controller_folder}/_local.js"
      action_js = "#{controller_folder}/#{action_name}.js"
      
      Dir.mkdir(namespace_folder) unless (namespace_folder.nil? || Dir.exists?(namespace_folder))
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
      controller = namespace_folder.present? ? "#{namespace_name}/#{@controller_name}" : "#{@controller_name}"
      File.open(Paloma.index_js, 'a+'){ |f| 
        f << "\n//= require ./" + controller + "/_callbacks"
      }
    end
    
    
    private
    
    def split_arguments args
      arg = args.split(' ')
      
      namespace = arg[0].split('/')
      namespace_name = (namespace.length > 1) ? namespace[0] : nil
      namespace_folder = namespace_name.nil? ? nil : "#{Paloma.destination}/#{namespace_name}"
            
      controller = namespace_name.nil? ? 
                    namespace[0].split(' ') : namespace[1].split(' ')
      controller_folder = namespace_folder.nil? ? 
                            "#{Paloma.destination}/#{controller[0]}" : 
                            "#{namespace_folder}/#{controller[0]}"
      
      #return an array: 
      #  [namespace_name, namespace_folder, controller_name, controller_folder, action_name]
      files = [namespace_name, namespace_folder, controller[0], controller_folder, arg[1]]
    end
    
    
    def generate_from_template destination_filename
      filename = destination_filename.split('/').last
      content = File.read("#{Paloma.templates}/#{filename}").gsub(/controller/, @controller_name)
      File.open(destination_filename, 'w'){ |f| f.write(content) }
    end 
  end
end
