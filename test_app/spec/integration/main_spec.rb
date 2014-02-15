require 'spec_helper'


feature 'executing Paloma controller', :js => true do

  #
  #
  # Basic
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
        'params' => {}})
    end
  end


  context 'override default action' do
    it 'executes the specified action' do
      visit new_main_path
      request = page.evaluate_script 'Paloma.engine.lastRequest'

      expect(request).to eq({
        'controller' => 'Main',
        'action' => 'otherAction',
        'params' => {}})
    end
  end


  context 'override default controller/action' do
    it 'executes the specified controller/action' do
      visit edit_main_path(1)
      request = page.evaluate_script 'Paloma.engine.lastRequest'

      expect(request).to eq({
        'controller' => 'OtherMain',
        'action' => 'otherAction',
        'params' => {}})
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


  # context 'coming from a redirect' do
  #   before { visit foo_index_path }

  #   it 'executes next the Paloma action of the last Rails action' do
  #     last = page.evaluate_script 'window.called.pop()'
  #     expect(last).to eq 'Main#index'
  #   end
  # end


  # context 'when js params is passed' do
  #   it 'passes the parameters to Paloma controller action' do
  #     visit foo_path(1)
  #     parameter = page.evaluate_script 'window.parameter'

  #     expect(parameter).to eq 'Parameter From Paloma'
  #   end
  # end


  # context 'from namespaced controller' do
  #   it 'executes the corresponding Paloma controller action' do
  #     visit admin_bar_path(1)
  #     called = page.evaluate_script 'window.called.pop()'

  #     expect(called).to eq 'Admin/Bar#show'
  #   end
  # end


  # context 'when js(false) is triggered' do
  #   it 'does not append paloma hook' do
  #     visit edit_foo_path(1)

  #     page.should_not have_selector '.js-paloma-hook'
  #   end
  # end


  # context 'when requests from a controller with multiple name' do
  #   it 'executes the corresponding Paloma action' do
  #     visit multiple_names_path

  #     called = page.evaluate_script 'window.called.pop()'

  #     expect(called).to eq 'MultipleNames#index'
  #   end
  # end



end
