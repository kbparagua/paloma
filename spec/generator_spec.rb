require 'spec_helper'
require 'generator_spec/test_case'
require 'fileutils'

feature Paloma::SetupGenerator do
  include GeneratorSpec::TestCase
  destination "#{Rails.root}/tmp"
  
  before do
    prepare_destination
    run_generator
  end
  
  specify do
    destination_root.should have_structure {
      directory 'app' do
        directory 'assets' do
          directory 'javascripts' do
            directory 'paloma' do               
              file 'paloma.js'
              file 'index.js'   
            end
          end
        end
      end
    }
  end
end


feature Paloma::AddGenerator do
  include GeneratorSpec::TestCase
  destination "#{Rails.root}/tmp"
  arguments ['fake_controller/fake_action'] 
  
  before do
    run_generator
  end

  specify do
    destination_root.should have_structure {
      directory 'app' do
        directory 'assets' do
          directory 'javascripts' do
            directory 'paloma' do               
              directory 'fake_controller' do
                file 'fake_action.js'
              end  
            end
          end
        end
      end
    }
  end 
end
