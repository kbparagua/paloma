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

  # No request should fail with 500 server error
  after do
    expect(page).to have_no_content("Internal Server Error")
  end

  context 'default behavior' do
    it 'executes the same controller/action' do
      visit main_index_path

      expect(request).to eq({
        'controller' => 'Main',
        'action' => 'index',
        'params' => {}})
    end
  end


  context 'override default controller' do
    it 'executes the specified controller' do
      visit main_path(1)

      expect(request).to eq({
        'controller' => 'OtherMain',
        'action' => 'show',
        'params' => {'x' => 1}})
    end
  end


  context 'override default action' do
    it 'executes the specified action' do
      visit new_main_path

      expect(request).to eq({
        'controller' => 'Main',
        'action' => 'otherAction',
        'params' => {'x' => 1}})
    end
  end


  context 'override default controller/action' do
    it 'executes the specified controller/action' do
      visit edit_main_path(1)

      expect(request).to eq({
        'controller' => 'OtherMain',
        'action' => 'otherAction',
        'params' => {'x' => 1}})
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

  context 'rss format response' do
    before { visit rss_format_main_index_path }
    include_examples 'no paloma'
  end

  context 'json format response' do
    before { visit json_format_main_index_path }
    include_examples 'no paloma'
  end


end
