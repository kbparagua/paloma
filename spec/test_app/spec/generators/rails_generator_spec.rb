require 'spec_helper'
require 'generator_helper'


feature ::Rails::Generators::ControllerGenerator, 'generating a rails controller without action' do
  init
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
          controller_structure 'my_controller'
        end
      end
    }
  end
end


feature ::Rails::Generators::ControllerGenerator, 'generating a rails controller with actions' do
  init
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
          controller_structure 'my_controller'
          action_js 'my_controller', 'new'
          action_js 'my_controller', 'edit'
        end
      end
    }
  end
end