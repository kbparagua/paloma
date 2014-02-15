require 'spec_helper'

#
#
# All examples are using namespaces
#
#

feature 'executing Paloma controller', :js => true do


  context 'default behavior' do
    it 'executes the same namespace/controller/action' do
      visit admin_foos_path

      expect(request).to eq({
        'controller' => 'Admin/Foos',
        'action' => 'index',
        'params' => {}})
    end
  end


  context 'override default controller' do
    it 'executes the specified controller' do
      visit admin_foo_path(1)

      expect(request).to eq({
        'controller' => 'NotAdmin/Foos',
        'action' => 'show',
        'params' => {'x' => 99}})
    end
  end


  context 'override default action' do
    it 'executes the specified action' do
      visit new_admin_foo_path

      expect(request).to eq({
        'controller' => 'Admin/Foos',
        'action' => 'otherAction',
        'params' => {'x' => 99}})
    end
  end


  context 'override default controller/action' do
    it 'executes the specified controller/action' do
      visit edit_admin_foo_path(1)

      expect(request).to eq({
        'controller' => 'NotAdmin/Foos',
        'action' => 'otherAction',
        'params' => {'x' => 99}})
    end
  end


end