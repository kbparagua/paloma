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
      
      generate_namespace_folder if @namespace.present?
      generate_controller_folder if @controller.present?
      generate_action_files(actions) if actions.present?
    end
    
    
    
  private
    
    
    def initialize_arguments args
      # split controller from actions
      arg = args.split(' ')
      @controller_path = arg[0]
      
      full_controller_path = @controller_path.split '/'
      @controller = full_controller_path.pop
      @namespace = full_controller_path.join '/'
      @namespace_folder = "#{Paloma.destination}/#{@namespace}" if @namespace 
      @controller_folder = "#{Paloma.destination}/#{@controller_path}"
    end
    
    
    def generate_namespace_folder
      return true if @namespace_folder.nil? || Dir.exists?(@namespace_folder)
      
      Dir.mkdir(@namespace_folder)
      
      generate_from_template :template => '/namespace/_locals.js',
        :filename => "#{@namespace_folder}/_locals.js",
        :replace => {':namespace' => @namespace_name}
        
      generate_from_template :template => '/namespace/_manifest.js',
        :filename => "#{@namespace_folder}/_manifest.js",
        :replace => {':controller' => @controller}
      
      # Require _manifest.js to Paloma's main index file
      File.open(Paloma.index_js, 'a+'){ |f| 
        f << "\n//= require ./#{@namespace}/_manifest.js" 
      }
    end
    
    
    def generate_controller_folder
      return true if @controller_folder.nil? || Dir.exists?(@controller_folder)
      
      Dir.mkdir(@controller_folder)
      
      generate_from_template :template => '_locals.js', 
        :filename => "#{@controller_folder}/_locals.js",
        :replace => {
          ':controller_path' => @controller_path,
          ':controller' => @controller,
          ':parent' => @namespace.present? @namespace : '/'}

      generate_from_template :template => '/controller/_manifest.js', 
        :filename => "#{@controller_folder}/_manifest.js"
      
      if @namespace.present?
        # Require _manifest.js to namespace's _manifest.js file
        File.open("#{@namespace_folder}/_manifest.js", 'a+'){ |f| 
          f << "\n//= require ./#{@controller}/_manifest.js"}
      else
        # Require _manifest.js to Paloma's main index file
        File.open(Paloma.index_js, 'a+'){ |f| 
          f << "\n//= require ./#{@controller}/_manifest.js" }
      end
    end
    
    
    def generate_action_files actions
      actions.each do |action|
        action_js = "#{@controller_folder}/#{action}.js"
        next if action.nil? || File.exists?(action_js)
        
        content = File.read("#{Paloma.templates}/controller/action.js").
          gsub(':controller_path', @controller_path).
          gsub(':action', action)
          
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
