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

      expect(
        request['controller'] == 'Admin/Foos' &&
        request['action'] == 'index' &&
        request['params'] == {}
      ).to be_truthy
    end
  end


  context 'override default controller' do
    it 'executes the specified controller' do
      visit admin_foo_path(1)

      expect(
        request['controller'] == 'NotAdmin/Foos' &&
        request['action'] == 'show' &&
        request['params'] == {'x' => 99}
      ).to be_truthy
    end
  end


  context 'override default action' do
    it 'executes the specified action' do
      visit new_admin_foo_path

      expect(
        request['controller'] == 'Admin/Foos' &&
        request['action'] == 'otherAction' &&
        request['params'] == {'x' => 99}
      ).to be_truthy
    end
  end


  context 'override default controller/action' do
    it 'executes the specified controller/action' do
      visit edit_admin_foo_path(1)

      expect(
        request['controller'] == 'NotAdmin/Foos' &&
        request['action'] == 'otherAction' &&
        request['params'] == {'x' => 99}
      ).to be_truthy
    end
  end


end
