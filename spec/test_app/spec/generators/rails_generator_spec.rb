require 'spec_helper'
require 'generator_helper'

=begin
feature ::Rails::Generators::ControllerGenerator, 'generating a rails controller without action' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['my_controller']
  
  before do
    prepare_destination
    mimic_setup  
    run_generator
  end   
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'my_controller' do
          file '_local.js' do
            contains 'Paloma.my_controller = {'
          end
          
          file '_callbacks.js' do
            contains '//= require ./_local.js'
            contains '//= require_tree .'
          end
        end
      end
    }
  end
end


feature ::Rails::Generators::ControllerGenerator, 'generating a rails controller with actions' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['my_controller', 'new', 'edit']
  
  before do
    prepare_destination
    
    # Create config/routes.rb
    FileUtils.cd TEMP
    FileUtils.mkpath 'config'
    File.open("config/routes.rb", 'w') { |f| f.write('')}
    
    mimic_setup  
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'my_controller' do
          file '_local.js' do
            contains 'Paloma.my_controller = {'
          end
          
          file '_callbacks.js' do
            contains '//= require ./_local.js'
            contains '//= require_tree .'
          end
          
          file 'new.js'
          file 'edit.js'
        end
      end
    }
  end
end
=end