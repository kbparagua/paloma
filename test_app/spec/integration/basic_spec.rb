require 'spec_helper'

#
#
# All examples are not using namespaces.
#
#

feature 'executing Paloma controller', :js => true do

  #
  #
  # Basic
  # All except for basic_params and index action will pass :x => 1 parameter
  #
  #

  context 'default behavior' do
    it 'executes the same controller/action' do
      visit main_index_path

      expect(
        request['controller'] == 'Main' &&
        request['action'] == 'index' &&
        request['params'] == {}
      ).to be_truthy
    end
  end


  context 'override default controller' do
    it 'executes the specified controller' do
      visit main_path(1)

      expect(
        request['controller'] == 'OtherMain' &&
        request['action'] == 'show' &&
        request['params'] == {'x' => 1}
      ).to be_truthy
    end
  end


  context 'override default action' do
    it 'executes the specified action' do
      visit new_main_path

      expect(
        request['controller'] == 'Main' &&
        request['action'] == 'otherAction' &&
        request['params'] == {'x' => 1}
      ).to be_truthy
    end
  end


  context 'override default controller/action' do
    it 'executes the specified controller/action' do
      visit edit_main_path(1)

      expect(
        request['controller'] == 'OtherMain' &&
        request['action'] == 'otherAction' &&
        request['params'] == {'x' => 1}
      ).to be_truthy
    end
  end


  context 'parameter passed' do
    it 'passes the parameter' do
      visit basic_params_main_index_path

      expect(request['params']).to eq({'x' => 1, 'y' => 2})
    end
  end





  #
  #
  # Multiple Calls
  #
  #

  context 'false at first then pass a parameter' do
    it 'executes default controller#action plus the parameter' do
      visit multiple_calls_1_main_index_path

      expect(
        request['controller'] == 'Main' &&
        request['action'] == 'multiple_calls_1' &&
        request['params'] == {'x' => 70}
      ).to be_truthy
    end
  end


  context 'false at first then pass a controller string' do
    it 'executes passed controller and default action' do
      visit multiple_calls_2_main_index_path

      expect(
        request['controller'] == 'OtherMain' &&
        request['action'] == 'multiple_calls_2'
      ).to be_truthy
    end
  end


  context 'controller at first then action' do
    it 'executes the controller and action' do
      visit multiple_calls_3_main_index_path

      expect(
        request['controller'] == 'OtherMain' &&
        request['action'] == 'show'
      ).to be_truthy
    end
  end


  context 'controller#action at first then false' do
    it 'does not execute any js' do
      visit multiple_calls_4_main_index_path
      expect(paloma_executed?).to be_falsy
    end
  end


  context 'false at first then true' do
    it 'executes default controller#action' do
      visit multiple_calls_5_main_index_path

      expect(
        request['controller'] == 'Main' &&
        request['action'] == 'multiple_calls_5'
      ).to be_truthy
    end
  end




  #
  #
  # Prevent Paloma
  #
  #

  shared_examples 'no paloma' do
    it 'does not add paloma hook' do
      expect(page.has_selector?('.js-paloma-hook')).to be_falsy
    end
  end


  context 'js(false)' do
    before { visit prevent_main_index_path }

    include_examples 'no paloma'

    it 'prevents execution of Paloma controller' do
      expect(paloma_executed?).to be_falsy
    end
  end

  context 'json response' do
    before { visit json_response_main_index_path }
    include_examples 'no paloma'
  end

  context 'js response' do
    before { visit js_response_main_index_path }
    include_examples 'no paloma'
  end

  context 'xml response' do
    before { visit xml_response_main_index_path }

    it 'does not add paloma hook' do
      # TODO: implement this
      # XML is not supported by capybara.
    end
  end

  context 'file response' do
    before { visit file_response_main_index_path }
    include_examples 'no paloma'
  end


end
