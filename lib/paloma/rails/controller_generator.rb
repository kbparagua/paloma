module ::Rails::Generators
  class ControllerGenerator < NamedBase 

    class_option :paloma, :type => :boolean, :default => true

    def paloma
      invoke 'paloma:add', ([file_name] + actions) if options[:paloma]
    end

  end
end
