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
      request = page.evaluate_script 'Paloma.engine.lastRequest'

      expect(request).to eq({
        'controller' => 'Main',
        'action' => 'index',
        'params' => {}})
    end
  end


  context 'override default controller' do
    it 'executes the specified controller' do
      visit main_path(1)
      request = page.evaluate_script 'Paloma.engine.lastRequest'

      expect(request).to eq({
        'controller' => 'OtherMain',
        'action' => 'show',
        'params' => {'x' => 1}})
    end
  end


  context 'override default action' do
    it 'executes the specified action' do
      visit new_main_path
      request = page.evaluate_script 'Paloma.engine.lastRequest'

      expect(request).to eq({
        'controller' => 'Main',
        'action' => 'otherAction',
        'params' => {'x' => 1}})
    end
  end


  context 'override default controller/action' do
    it 'executes the specified controller/action' do
      visit edit_main_path(1)
      request = page.evaluate_script 'Paloma.engine.lastRequest'

      expect(request).to eq({
        'controller' => 'OtherMain',
        'action' => 'otherAction',
        'params' => {'x' => 1}})
    end
  end


  context 'parameter passed' do
    it 'passes the parameter' do
      visit basic_params_main_index_path
      params = page.evaluate_script 'Paloma.engine.lastRequest.params'

      expect(params).to eq({'x' => 1, 'y' => 2})
    end
  end





  #
  #
  # Prevent Paloma
  #
  #

  shared_examples 'no paloma' do
    it 'does not add paloma hook' do
      expect(page.has_selector?('.js-paloma-hook')).to be_false
    end
  end


  context 'js(false)' do
    before { visit prevent_main_index_path }

    include_examples 'no paloma'

    it 'prevents execution of Paloma controller' do
      request = page.evaluate_script 'Paloma.engine.lastRequest'
      expect(request).to be_nil
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
    include_examples 'no paloma'
  end

  context 'file response' do
    before { visit file_response_main_index_path }
    include_examples 'no paloma'
  end


end
