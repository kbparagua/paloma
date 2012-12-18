module Paloma

  class CallbackGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    
    def copy_initializer_file
      copy_file "initializer.rb", "app/assets/javascripts/callbacks/#{file_name}.rb"
    end
    
    #desc "This generator creates an initializer file at config/initializers"
    #def create_initializer_file
    #  create_file "config/initializers/initializer.rb", "# Add initialization content here"
    #end
  end

end
