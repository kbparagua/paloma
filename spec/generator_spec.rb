require 'spec_helper'
require 'generator_spec/test_case'
require 'fileutils'

TEMP = "#{File.dirname(__FILE__)}/tmp/"

# rails g paloma:setup
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
  File.open("#{Paloma.destination}/index.js", 'w') { |f| f.write('//= require ./paloma.js')}
end


# rails g paloma:add sexy_controller
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
        directory 'sexy_controller' do
          file '_callbacks.js' do
            contains "//= require ./_local.js"
            contains "//= require_tree ."
          end
          
          file '_local.js' do
            contains "Paloma.sexy_controller = {"
          end
        end
        
        file 'index.js' do
          contains '//= require ./sexy_controller/_callbacks.js'
        end
      end
    }
  end
end


# rails g paloma:add namespace/new_controller_folder
feature Paloma::AddGenerator, 'creating a namespaced controller folder' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['namespace/new_controller_folder']
  
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
            file '_callbacks.js' do
              contains '//= require ./_local.js'
              contains '//= require_tree .'
            end
            
            file '_local.js' do
              contains 'Paloma.namespace.new_controller_folder = {'
            end
          end
          file '_callbacks.js' do
            contains "//= require ./_local.js"
            contains "//= require ./new_controller_folder/_callbacks.js"
          end
          
          file '_local.js' do
            contains "Paloma.namespace = {"
          end
        end
        file 'index.js' do
          contains "//= require ./namespace/_callbacks.js"
        end
      end
    }
  end
end


# rails g paloma:add new_controller_folder new_action
feature Paloma::AddGenerator, 'creating both controller folder and action file' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['new_controller_folder', 'new_action']
  
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
          
          file '_callbacks.js' do
            contains "//= require ./_local.js"
            contains "//= require_tree ."
          end
          
          file '_local.js' do
            contains "Paloma.new_controller_folder = {"  
          end
        end
        
        file 'index.js' do
          contains "//= require ./new_controller_folder/_callbacks.js"
        end        
      end
    }
  end
end


# rails g paloma:add existing_controller_folder new_action
feature Paloma::AddGenerator, 'creating action with existing controller folder' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['existing_controller_folder', 'new_action']
  
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
        end
      end
    }
  end
end


# rails g paloma:add namespace/new_controller_folder new_action
feature Paloma::AddGenerator, 'creating namespaced controller folder and action file' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['namespace/new_controller_folder', 'new_action']
  
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
              contains "Paloma.callbacks['namespace/new_controller_folder/new_action']"
            end
          end
          
          file '_callbacks.js' do
            contains "//= require ./_local.js"
            contains "//= require ./new_controller_folder/_callbacks.js"
          end
          
          file '_local.js' do
            contains "Paloma.namespace = {"
          end
        end
        
        file 'index.js' do
          contains "//= require ./namespace/_callbacks.js"
        end
      end
    }
  end  
end


# rails g paloma:add existing_namespace/new_controller_folder new_action
feature Paloma::AddGenerator, 'creating controller folder and action file under an existing namespace' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['existing_namespace/new_controller_folder', 'new_action']
  
  before do
    prepare_destination
    mimic_setup
    Dir.mkdir "#{Paloma.destination}/namespace"
    
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'existing_namespace' do
          directory 'new_controller_folder' do
            file 'new_action.js' do
              contains "Paloma.callbacks['existing_namespace/new_controller_folder/new_action']"
            end
            
            file '_local.js' do
              contains 'Paloma.existing_namespace.new_controller_folder = {'
            end
          end
          
          file '_callbacks.js' do
            contains "//= require ./new_controller_folder/_callbacks.js"
          end
        end    
      end
    }
  end
end


# rails g paloma:add new_controller_folder first_action second_action third_action
feature Paloma::AddGenerator, 'create controller folder and multiple action files' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['new_controller_folder', 'first_action', 'second_action', 'third_action']
  
  before do
    prepare_destination
    mimic_setup
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'new_controller_folder' do
          file '_local.js' do
            contains 'Paloma.new_controller_folder = {'
          end
          
          file 'first_action.js' do
            contains "Paloma.callbacks['new_controller_folder/first_action']"
          end
          
          file 'second_action.js' do
            contains "Paloma.callbacks['new_controller_folder/second_action']"
          end
          
          file 'third_action.js' do
            contains "Paloma.callbacks['new_controller_folder/third_action']"
          end
        end
        
        file 'index.js' do
          contains '//= require ./new_controller_folder/_callbacks.js'
        end
      end
    }
  end
end


# rails g paloma:add existing_controller_folder first_action second_action third_action
feature Paloma::AddGenerator, 'create multiple actions in an existing controller folder' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['existing_controller_folder', 'first_action', 'second_action', 'third_action']
  
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
          ['first', 'second', 'third'].each do |action|
            file ("#{action}_action.js") do
              contains "Paloma.callbacks['existing_controller_folder/#{action}_action']"
            end
          end
        end
      end
    }
  end
end


# rails g paloma:add namespace/new_controller_folder first_action second_action third_action
feature Paloma::AddGenerator, 'create multiple actions in a new namespaced controller' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['namespace/new_controller_folder', 'first_action', 'second_action', 'third_action']
  
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
            file '_local.js' do
              contains 'Paloma.namespace.new_controller_folder'
            end
            
            ['first', 'second', 'third'].each do |action|
              file ("#{action}_action.js") do
                contains "Paloma.callbacks['namespace/new_controller_folder/#{action}_action']"
              end
            end
          end
          file '_callbacks.js' do
            contains '//= require ./new_controller_folder/_callbacks.js'
          end 
          
          file '_local.js' do
            contains 'Paloma.namespace'
          end
        end
        file 'index.js' do
          contains '//= require ./namespace/_callbacks.js'
        end
      end
    }
  end
end


# rails g paloma:add existing_names/new_controller_folder first_action second_action third_action
feature Paloma::AddGenerator, 'create multiple actions in an existing namespaced controller' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['existing_namespace/new_controller_folder', 'first_action', 'second_action', 'third_action']
  
  before do
    prepare_destination
    mimic_setup
    Dir.mkdir "#{Paloma.destination}/existing_namespace"
    File.open("#{Paloma.destination}/existing_namespace/_callbacks.js", 'w'){ |f| 
      f.write('//= require ./_local.js') }
    
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'existing_namespace' do
          directory 'new_controller_folder' do
            ['first', 'second', 'third'].each do |action|
              file ("#{action}_action.js") do
                contains "Paloma.callbacks['existing_namespace/new_controller_folder/#{action}_action']"
              end
            end
            
            file '_local.js' do
              contains 'Paloma.existing_namespace.new_controller_folder'
            end
          end
          file '_callbacks.js' do
            contains '//= require ./new_controller_folder/_callbacks.js'
          end
        end
      end
    }
  end
end
