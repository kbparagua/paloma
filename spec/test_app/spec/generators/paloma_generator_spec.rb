require 'spec_helper'
require 'generator_helper'


# rails g paloma:setup
describe Paloma::SetupGenerator do    
  init

  before do
    prepare_destination
    run_generator
  end

  specify do
    destination_root.should have_structure {
      directory Paloma.destination do  
        file 'index.js'
        filters_js '/'
        locals_js '/'
      end
    }
  end
end


# rails g paloma:add sexy_controller
feature Paloma::AddGenerator, 'creating controller folder' do
  init
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
          controller_structure 'sexy_controller'
        end
      end
    }
  end
end

# rails g paloma:add namespace/new_controller
feature Paloma::AddGenerator, 'creating a namespaced controller folder' do
  init
  arguments ['namespace/new_controller']

  before do
    prepare_destination
    mimic_setup
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'namespace' do
          directory 'new_controller' do
            controller_structure 'namespace/new_controller', :parent => 'namespace'
          end

          namespace_structure 'namespace'
        end

        file 'index.js' do
          contains "//= require ./namespace/_manifest.js"
        end
      end
    }
  end
end


# rails g paloma:add new_controller action1 action2
feature Paloma::AddGenerator, 'creating both controller folder and action files' do
  init
  arguments ['new_controller', 'action1', 'action2']
  
  before do
    prepare_destination
    mimic_setup
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'new_controller' do
          action_js 'new_controller', 'action1'
          action_js 'new_controller', 'action2'
          controller_structure 'new_controller'
        end
        
        file 'index.js' do
          contains "//= require ./new_controller/_manifest.js"
        end
      end
    }
  end
end


# rails g paloma:add existing_controller action1 action2
feature Paloma::AddGenerator, 'creating actions with existing controller folder' do
  init
  arguments ['existing_controller', 'action1', 'action2']
  
  before do
    prepare_destination
    mimic_setup
    Dir.mkdir "#{Paloma.destination}/existing_controller"
    
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'existing_controller' do
          action_js 'existing_controller', 'action1'
          action_js 'existing_controller', 'action2'
        end
      end
    }
  end
end


# rails g paloma:add namespace/new_controller action1 action2
feature Paloma::AddGenerator, 'creating namespaced controller folder and action files' do
  include GeneratorSpec::TestCase
  destination TEMP
  arguments ['namespace/new_controller', 'action1', 'action2']
  
  before do
    prepare_destination
    mimic_setup    
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'namespace' do
          directory 'new_controller' do
            action_js 'namespace/new_controller', 'action1'
            action_js 'namespace/new_controller', 'action2'
            controller_structure 'namespace/new_controller', :parent => 'namespace'
          end
          
          namespace_structure 'namespace'
        end
        
        file 'index.js' do
          contains "//= require ./namespace/_manifest.js"
        end
      end
    }
  end  
end


# rails g paloma:add existing_namespace/new_controller_folder new_action
feature Paloma::AddGenerator, 'creating controller folder and action file under an existing namespace' do
  init
  arguments ['existing_namespace/new_controller', 'action1', 'action2']
  
  before do
    prepare_destination
    mimic_setup
    Dir.mkdir "#{Paloma.destination}/existing_namespace"
    
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory Paloma.destination do
        directory 'existing_namespace' do
          directory 'new_controller' do
            action_js 'existing_namespace/new_controller', 'action1'
            action_js 'existing_namespace/new_controller', 'action2'
            controller_structure 'existing_namespace/new_controller', 
              :parent => 'existing_namespace'
          end

          file '_manifest.js' do
            contains "//= require ./new_controller/_manifest.js"
          end
        end    
      end
    }
  end
end