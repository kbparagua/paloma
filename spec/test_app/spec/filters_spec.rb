require 'spec_helper'

describe 'Paloma.FilterScope', :type => :feature, :js => true do
  
  shared_examples 'standard' do |options|
    type = options[:type]
    name = options[:name]
    method = options[:method] || "##{type}"
    
    describe method do
      it "executes filter #{type} callbacks for the passed actions" do
        visit basic_action_bar_path
        page.evaluate_script("filtersExecuted.#{type}").should include "Standard #{name}"
      end
    
      it "does not execute filter #{type} callbacks for other actions" do
        visit yet_another_basic_action_bar_path
        page.evaluate_script("filtersExecuted.#{type}").should_not include "Standard #{name}"
      end
    end
  end
  
  
  shared_examples 'all' do |options|
    type = options[:type]
    name = options[:name]
    method = options[:method] || "##{type}_all"
    
    describe method do
      it "executes filter #{type} callbacks on all actions" do
        visit basic_action_bar_path
        page.evaluate_script("filtersExecuted.#{type}").should include "#{name} All"
      end      
    end    
  end
  
  
  shared_examples 'except' do |options|
    type = options[:type]
    name = options[:name]
    method = options[:method] || "#except_#{type}"
    
    describe method do
      it "executes filter #{type} callback on all actions except for passed actions" do
        visit another_basic_action_bar_path
        page.evaluate_script("filtersExecuted.#{type}").should include "Except #{name}"
      end

      it "does not execute filter #{type} callback on passed actions" do
        visit basic_action_bar_path
        page.evaluate_script("filtersExecuted.#{type}").should_not include "Except #{name}"
      end
    end
  end
  
  
  shared_examples 'filter subtypes' do |type|
    options = {:type => type, :name => type.titleize}
    include_examples 'standard', options
    include_examples 'all', options
    include_examples 'except', options
  end
  
  include_examples 'filter subtypes', 'before'
  include_examples 'filter subtypes', 'after'
  
  
  include_examples 'standard', {:name => 'Around', :type => 'before', :method => '#around'}
  include_examples 'standard', {:name => 'Around', :type => 'after', :method => '#around'}
  include_examples 'all', {:name => 'Around', :type => 'before', :method => '#around_all'}
  include_examples 'all', {:name => 'Around', :type => 'after', :method => '#around_all'}
  include_examples 'except', {:name => 'Around', :type => 'before', :method => '#except_around'}
  include_examples 'except', {:name => 'Around', :type => 'after', :method => '#except_around'}
  
end
