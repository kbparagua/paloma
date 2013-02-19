require 'spec_helper'

feature 'Filters', :js => true do
  
  specify 'beforeFilter == foo/basic_action' do
    visit callback_from_another_action_foo_path
    #raise page.evaluate_script("Paloma._filters").inspect
    expect(page.evaluate_script('beforeFilter')).to eq('foo/basic_action')
  end
  
end
