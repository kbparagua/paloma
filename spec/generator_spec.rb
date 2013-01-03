require 'spec_helper'
require 'generator_spec/test_case'
require 'fileutils'

TEMP = "#{File.dirname(__FILE__)}/tmp/"

feature Paloma::SetupGenerator do
  include GeneratorSpec::TestCase
  destination TEMP
  
  before do
    prepare_destination
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        file 'paloma.js'
        file 'index.js'
      end
    }
  end
end



def mimic_setup
  # Mimic SetupGenerator results before running the AddGenerator
  FileUtils.cd TEMP
  FileUtils.mkpath Paloma.destination
  File.open("#{Paloma.destination}/index.js", 'w') { |f| f.write('// test')}
end



feature Paloma::AddGenerator, 'creating controller folder only' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['sexy_controller']
  
  before do
    prepare_destination
    mimic_setup
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'sexy_controller'
        
        file 'index.js' do
          contains '//= require ./sexy_controller/_callbacks'
        end
      end
    }
  end
end



feature Paloma::AddGenerator, 'creating action with existing controller folder' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['existing_controller_folder new_action']
  
  before do
    prepare_destination
    mimic_setup
    Dir.mkdir "#{Paloma.destination}/existing_controller_folder"
    
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'existing_controller_folder' do
          file 'new_action.js' do
            contains "Paloma.callbacks['existing_controller_folder/new_action']"
          end
          
          file '_callbacks.js' do
            contains "//= require ./_local.js"
            contains "//= require_tree ."
          end
        end
      end
    }
  end
end



feature Paloma::AddGenerator, 'creating both controller folder and action file' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['new_controller_folder new_action']
  
  before do
    prepare_destination
    mimic_setup
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'new_controller_folder' do
          file 'new_action.js' do
            contains "Paloma.callbacks['new_controller_folder/new_action']"
          end
        end
      end
    }
  end
end



feature Paloma::AddGenerator, 'creating namespaced controller folder and action file' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['namespace/new_controller_folder new_action']
  
  before do
    prepare_destination
    mimic_setup    
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'namespace' do
          directory 'new_controller_folder' do
            file 'new_action.js' do
              contains "Paloma.callbacks['new_controller_folder/new_action']"
            end
          end
        end
      end
    }
  end  
end



feature Paloma::AddGenerator, 'creating controller folder and action file under an existing namespace' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['namespace/new_controller_folder new_action']
  
  before do
    prepare_destination
    mimic_setup
    Dir.mkdir "#{Paloma.destination}/namespace"
    
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'namespace' do
          directory 'new_controller_folder' do
            file 'new_action.js' do
              contains "Paloma.callbacks['new_controller_folder/new_action']"
            end
          end
        end
        
        file 'index.js' do
          contains '//= require ./namespace/new_controller_folder/_callbacks'
        end        
      end
    }
  end
end
