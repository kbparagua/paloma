require 'rails/generators/named_base'
require 'rails/generators/rails/controller/controller_generator'
require 'fileutils'
require 'generator_spec/test_case'


TEMP = "#{File.dirname(__FILE__)}/tmp/"

# We override the original Paloma.destination
# so that when run_generator command is executed by the specs
# Paloma.destination will point to /spec/tmp instead of /test_app itself.
$test_destination = "#{TEMP}#{Paloma.destination}"
module Paloma
  def self.destination
    $test_destination
  end
end


def mimic_setup
  # Mimic SetupGenerator results before running the AddGenerator
  FileUtils.cd TEMP
  FileUtils.mkpath Paloma.destination
  File.open("#{Paloma.destination}/index.js", 'w') { 
    |f| f.write('//= require ./paloma_core.js')
  }
end


def init
  include GeneratorSpec::TestCase
  destination TEMP
end



module GeneratorSpec::Matcher
  class Directory

    def manifest_js
      file '_manifest.js'
    end


    def filters_js scope
      file '_filters.js' do
        contains "var filter = new Paloma.FilterScope('#{scope}');"
      end
    end


    def locals_js scope, options = {:parent => nil, :is_controller => false}
      file '_locals.js' do
        contains "var locals = Paloma.locals['#{scope}'] = {};"
        
        if options[:parent].present?
          contains "Paloma.inheritLocals({from : '#{options[:parent]}', to : '#{scope}'});"
        end

        if options[:is_controller]
          contains "Paloma.callbacks['#{scope}'] = {};"
        end
      end
    end


    def action_js controller, action
      file "#{action}.js" do
        contains "Paloma.callbacks['#{controller}']['#{action}']"
      end  
    end


    def controller_structure controller, options = {:parent => '/'}
      manifest_js
      filters_js controller
      locals_js controller, :parent => options[:parent], :is_controller => true
    end


    def namespace_structure namespace 
      manifest_js
      locals_js namespace, :parent => '/'
      filters_js namespace
    end
  end
end
