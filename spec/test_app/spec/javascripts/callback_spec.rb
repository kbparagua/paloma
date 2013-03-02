require 'spec_helper'


describe 'Paloma callback', :type => :feature, :js => true do

  context 'when js(false)' do
    it 'is not executed' do
      visit skip_callback_foo_path
      page.evaluate_script('window["callback"] === undefined').should be_true
    end
  end


  context 'when js(:controller => "controller", :action => "action")' do
    it 'is ["controller"]["action"]' do 
      visit callback_from_another_controller_foo_path
      page.evaluate_script('callback').should eq "['bar']['basic_action']"
    end
  end
  
  
  context 'when js(:controller => "namespace/controller", :action => "action"' do
    it 'is ["namespace/controller"]["action"]' do
      visit callback_from_namespaced_controller_foo_path
      page.evaluate_script('callback').should eq "['sample_namespace/baz']['basic_action']"
    end
  end


  context 'within a non-namespaced controller' do
    context 'when js() is not directly invoked' do
      it 'is ["request_controller"]["request_action"]' do
        visit basic_action_foo_path
        page.evaluate_script('callback').should eq "['foo']['basic_action']"
      end
    end
    
    
    context 'when js(:action)' do
      it 'is ["request_controller"][:action]' do
        visit callback_from_another_action_foo_path
        page.evaluate_script('callback').should eq "['foo']['basic_action']"
      end
    end    
  end
  
  
  context 'within a namespaced controller' do
    context 'when js() is not directly invoked' do
      it 'is ["request_namespace/request_controller"]["request_action"]' do
        visit basic_action_sample_namespace_baz_path
        page.evaluate_script('callback').should eq "['sample_namespace/baz']['basic_action']"
      end
    end
    
    
    context 'when js(:action)' do
      it 'is ["request_namespace/request_controller"][:action]' do
        visit callback_from_another_action_sample_namespace_baz_path
        page.evaluate_script('callback').should eq "['sample_namespace/baz']['basic_action']"
      end
    end
  end
end
