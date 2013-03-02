require 'spec_helper'


describe 'Locals', :type => :feature, :js => true do

  before do
    visit basic_action_foo_path
  end


  describe '_l' do
    it 'has access to local methods' do
      page.evaluate_script('helperMethodValue').should be 100
    end


    it 'has access to local variables' do
      page.evaluate_script('helperVariableValue').should be 99
    end


    it 'can override locals from its parent scope' do
      page.evaluate_script('overriden').should eq 'Override!'
    end
  end

end