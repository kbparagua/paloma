require 'spec_helper'

feature 'Callbacks', :js => true do

  specify 'callback == foo/basic_action' do
    visit basic_action_foo_path
    expect(page.evaluate_script('callback')).to eq('foo/basic_action')
  end
  
  specify 'callback == foo/basic_action instead of foo/callback_from_another_action' do
    visit callback_from_another_action_foo_path
    expect(page.evaluate_script('callback')).to eq('foo/basic_action')
  end
  
  specify 'callback == bar/basic_action instead of foo/callback_from_another_controller' do
    visit callback_from_another_controller_foo_path
    expect(page.evaluate_script('callback')).to eq('bar/basic_action')
  end
  
  specify 'callback == undefined instead of foo/skip_callback' do
    visit skip_callback_foo_path
    expect(page.evaluate_script('window["callback"] === undefined')).to eq(true)
  end
  
  specify ('callback == sample_namespace/baz/basic_action instead of' + 
    'foo/callback_from_namespaced_controller') do
    visit callback_from_namespaced_controller_foo_path
    expect(page.evaluate_script('callback')).to eq('sample_namespace/baz/basic_action')
  end
 
end
