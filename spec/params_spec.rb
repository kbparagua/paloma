require 'spec_helper'

feature 'Paloma params', :js => true do
  
  describe 'Non-namespaced callback' do
    before do
      visit callback_from_another_action_foo_path
    end
    
    specify 'callback_controller == foo' do
      expect(page.evaluate_script('params.callback_controller')).to eq('foo')
    end
    
    specify 'callback_action == callback_from_different_action' do
      expect(page.evaluate_script('params.callback_action')).to eq('callback_from_different_action')
    end     
    
    specify 'callback_namespace should be empty' do
      expect(page.evaluate_script('params.callback_namespace')).to eq('')
    end
    
    specify 'callback_controller_path == foo' do
      expect(page.evaluate_script('params.callback_controller_path')).to eq('foo')
    end
  end
  
=begin  
  describe 'Namespaced callback' do
    before do
      visit sample_namespace_categories_path
    end
    
    specify 'callback_controller == categories' do
      expect(page.evaluate_script('params.callback_controller')).to eq('categories')
    end
    
    specify 'callback_controller_path == sample_namespace/categories' do
      expect(page.evaluate_script('params.callback_controller_path')).to eq('sample_namespace/categories')
    end
    
    specify 'callback_action == index' do
      expect(page.evaluate_script('params.callback_action')).to eq('index')  
    end
    
    specify 'callback_namespace == sample_namespace' do
      expect(page.evaluate_script('params.callback_namespace')).to eq('sample_namespace')      
    end  
  end
=end
end
