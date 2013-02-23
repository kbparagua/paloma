require 'spec_helper'

describe 'Callback params', :type => :feature, :js => true do
  
  shared_examples 'check params' do |params|
    specify "callback_controller must be the callback's controller" do
      page.evaluate_script('params.callback_controller').should eq params[:callback_controller]
    end
    
    specify "callback_action must be the callback's action" do
      page.evaluate_script('params.callback_action').should eq params[:callback_action]
    end
    
    specify "callback_namespace must be callback's namespace" do
      page.evaluate_script('params.callback_namespace').should eq params[:callback_namespace]
    end
    
    specify "callback_controller_path must be callback's namespace and controller" do
      page.evaluate_script('params.callback_controller_path').should eq params[:callback_controller_path]
    end
    
    specify "controller must be request's controller" do
      page.evaluate_script('params.controller').should eq params[:controller]
    end
    
    specify "action must be request's action" do
      page.evaluate_script('params.action').should eq params[:action]
    end
    
    specify "namespace must be request's namespace" do
      page.evaluate_script('params.namespace').should eq params[:namespace]
    end
    
    specify "controller_path must be request's namespace and controller" do
      page.evaluate_script('params.controller_path').should eq params[:controller_path]
    end
  end


  context 'within a non-namespaced callback' do
    before do
      visit callback_from_another_action_foo_path
    end
    
    include_examples('check params', {
      :controller => 'foo',
      :action => 'callback_from_another_action',
      :namespace => '',
      :controller_path => 'foo',
      :callback_controller => 'foo',
      :callback_action => 'basic_action',
      :callback_namespace => '',
      :callback_controller_path => 'foo'})
  end    
end
