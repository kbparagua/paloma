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
    argument :actions, :type => :array, :required => false
    
    def create_callback_file
      args = split_arguments(file_path)
      
      @namespace_name = args[0]
      @namespace_folder = args[1]
      @controller_name = args[2]
      @controller_folder = args[3]
      
      generate_folder(@namespace_folder)
      generate_folder(@controller_folder)

      # Create a js file for action if there is an action argument
      if actions.present?
        generate_actions actions  
      end
    end
    
    
    private
    
    def split_arguments args
      #split controller from actions
      arg = args.split(' ')
      
      #Split namespace from controller
      namespace = arg[0].split('/')
      namespace_name = (namespace.length > 1) ? namespace[0] : nil
      namespace_folder = namespace_name.nil? ? nil : "#{Paloma.destination}/#{namespace_name}"
            
      controller_name = namespace_name.nil? ? namespace[0].split(' ')[0] : namespace[1].split(' ')[0]
      controller_folder = namespace_folder.nil? ? 
                            "#{Paloma.destination}/#{controller_name}" : 
                            "#{namespace_folder}/#{controller_name}"
       
      # [namespace_name, namespace_folder, controller_name, controller_folder]
      files = [namespace_name, namespace_folder, controller_name, controller_folder]
    end
    
    
    def generate_actions actions
      actions.each do |action|
        action_js = "#{@controller_folder}/#{action}.js"
        if action.present? && !File.exists?(action_js)
          controller_path = @namespace_name.nil? ? @controller_name : "#{@namespace_name}/#{@controller_name}"
          
          content = File.read("#{Paloma.templates}/action.js").gsub(
            /controller\/action/, 
            "#{controller_path}/#{action}")
            
          File.open(action_js, 'w'){ |f| f.write(content) }
          
          puts "create #{action_js}"  
        end
      end
    end
    
    
    def generate_folder folder
      unless (folder.nil? || Dir.exists?(folder))
        Dir.mkdir(folder)  
        
        callbacks_js = "#{folder}/_callbacks.js"
        local_js = "#{folder}/_local.js"
        
        generate_from_template local_js unless File.exists?(local_js)
        generate_from_template callbacks_js unless File.exists?(callbacks_js)
        
        if folder == @namespace_folder
          content = File.read(callbacks_js).gsub('//= require_tree .', '')
          File.open(callbacks_js, 'w'){ |f| f.write(content) }
        end
        
        require_callbacks folder  
      end
    end
    
    
    def require_callbacks folder
      # Require controller's _callbacks.js to Paloma's main index.js file.
      # Located on "#{Paloma.destination}/index.js" or by default on
      # app/assets/javascripts/paloma/index.js
      
      if (@namespace_folder.present? && folder != @namespace_folder)
        File.open("#{@namespace_folder}/_callbacks.js", 'a+'){ |f|
          is_present = f.lines.grep("\n//= require ./#{@controller_name}/_callbacks.js").any?
          f << "\n//= require ./#{@controller_name}/_callbacks.js" unless is_present
        }
      end
       
      controller = @namespace_folder.present? ? @namespace_name : @controller_name
      
      unless (@namespace_folder.present? && folder != @namespace_folder)
        File.open(Paloma.index_js, 'a+'){ |f|
          f << "\n//= require ./#{controller}/_callbacks.js"
        }
      end
    end
    
    
    def generate_from_template destination_filename
      controller = destination_filename.gsub(/[\/|\w|_]+\/paloma\//, '')
      
      filename = controller.split('/').last
      controller = controller.gsub('/' + filename, '')
      controller = controller.gsub('/', '.')
      
      content = File.read("#{Paloma.templates}/#{filename}").gsub(/controller/, controller)
      File.open(destination_filename, 'w'){ |f| f.write(content) }
      puts "create #{destination_filename}"
    end 
  end
end
