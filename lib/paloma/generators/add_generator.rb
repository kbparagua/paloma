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
      initialize_arguments file_path
      
      generate_namespace_folder if @namespace_folder.present?
      generate_controller_folder if @controller_folder.present?
      generate_action_files(actions) if actions.present?
    end
    
    
    
  private
    
    
    def initialize_arguments args
      # split controller from actions
      arg = args.split(' ')
      
      # Split namespace from controller
      controller = arg[0].split('/')
      @namespace_name = (controller.length > 1) ? controller[0] : '' 
      @namespace_folder = @namespace_name.present? ? 
        "#{Paloma.destination}/#{@namespace_name}" : 
        nil
            
      @controller_name = @namespace_name.present? ? controller[1] : controller[0]
      @controller_folder = @namespace_folder.present? ?  
        "#{@namespace_folder}/#{@controller_name}" :
        "#{Paloma.destination}/#{@controller_name}"
    end
    
    
    def generate_namespace_folder
      return true if @namespace_folder.nil? || Dir.exists?(@namespace_folder)
      
      Dir.mkdir(@namespace_folder)
      
      generate_from_template :template => '_namespace_local.js',
        :filename => "#{@namespace_folder}/_local.js",
        :replace => {'namespace' => @namespace_name}
        
      generate_from_template :template => '_namespace_callbacks.js',
        :filename => "#{@namespace_folder}/_callbacks.js",
        :replace => {'controller' => @controller_name}
      
      # Require _callbacks.js to Paloma's main index file
      File.open(Paloma.index_js, 'a+'){ |f| f << "\n//= require ./#{@namespace_name}/_callbacks.js" }
    end
    
    
    def generate_controller_folder
      return true if @controller_folder.nil? || Dir.exists?(@controller_folder)
      
      Dir.mkdir(@controller_folder)
      
      generate_from_template :template => '_local.js', 
        :filename => "#{@controller_folder}/_local.js",
        :replace => {
          'controller' => @controller_name,
          'namespace/' => (@namespace_name.present? ? "#{@namespace_name}/" : ''),
          'namespace.' => (@namespace_name.present? ? "#{@namespace_name}." : '')}
   
      generate_from_template :template => '_callbacks.js', 
        :filename => "#{@controller_folder}/_callbacks.js"
      
      if @namespace_name.present?
        # Require _callback.js to namespace's _callback.js file
        File.open("#{@namespace_folder}/_callbacks.js", 'a+'){ |f| 
          f << "\n//= require ./#{@controller_name}/_callbacks.js"}
      else
        # Require _callback.js to Paloma's main index file
        File.open(Paloma.index_js, 'a+'){ |f| 
          f << "\n//= require ./#{@controller_name}/_callbacks.js" }
      end
    end
    
    
    def generate_action_files actions
      actions.each do |action|
        action_js = "#{@controller_folder}/#{action}.js"
        next if action.nil? || File.exists?(action_js)
        
        controller_path = @namespace_name.present? ? 
          "#{@namespace_name}/#{@controller_name}" : 
          @controller_name
        
        content = File.read("#{Paloma.templates}/action.js").
          gsub('controller', controller_path).
          gsub('action', action)
          
        File.open(action_js, 'w'){ |f| f.write(content) }
        puts "create #{action_js}"  
      end
    end
    
    
    def generate_from_template options = {:template => nil, :filename => nil, :replace => {}}
      return true if File.exists?(options[:filename])
      
      content = File.read("#{Paloma.templates}/#{options[:template]}")
      options[:replace].each do |pattern, value| 
        content.gsub!(pattern, value)
      end if options[:replace].present?
      
      File.open(options[:filename], 'w'){ |f| f.write(content) }
      puts "create #{options[:filename]}"
    end 
  end
end
