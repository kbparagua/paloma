require 'spec_helper'


describe '_x', :type => :feature, :js => true  do

  before do
    visit basic_action_foo_path
  end


  it 'is visible on filters and callback' do
    final_x = page.evaluate_script 'window.xVisibilityFinal'
    final_x.should eq ['Before Foo', 'Around Foo', 'Foo', 'After Foo', 'Around Foo']
  end


  it 'is empty after filter and callback executions' do
    x = page.evaluate_script 'Paloma.variableContainer'
    x.should be_empty
  end
end