require 'spec_helper'

describe 'Paloma.FilterScope', :type => :feature, :js => true do
  
  shared_examples 'filter subtypes' do |type|
    name = type.titleize
    
    describe "##{type}" do
      it "executes filter #{type} callbacks for the passed actions" do
        visit basic_action_bar_path
        page.evaluate_script('filtersExecuted').should include "Standard #{name}"
      end
    
      it "does not execute filter #{type} callbacks for other actions" do
        visit yet_another_basic_action_bar_path
        page.evaluate_script('filtersExecuted').should_not include "Standard #{name}"
      end
    end
    
    
    describe "##{type}_all" do
      it "executes filter #{type} callbacks on all actions" do
        visit basic_action_bar_path
        page.evaluate_script('filtersExecuted').should include "#{name} All"
      end      
    end
    
    
    describe "#except_#{type}" do
      it "executes filter #{type} callback on all actions except for passed actions" do
        visit another_basic_action_bar_path
        page.evaluate_script('filtersExecuted').should include "Except #{name}"
      end
      
      it "does not execute filter #{type} callback on passed actions" do
        visit basic_action_bar_path
        page.evaluate_script('filtersExecuted').should_not include "Except #{name}"
      end
    end
  end
  
  
  include_examples 'filter subtypes', 'before'
  include_examples 'filter subtypes', 'after'
  
  
  describe '#around' do
    it 'executes filter before calling callbacks for the passed actions' do
    
    end
    
    it 'executes filter after calling callbacks for the passed actions' do
    
    end
  end
  
  
  describe '#around_all' do
    it 'executes filter before calling callbacks for all actions' do
    
    end
    
    it 'executes filter after calling callbacks for all actions' do
    
    end 
  end
  
  
  describe '#except_around' do
    it 'executes filter before all actions except for passed actions' do
    
    end
    
    it 'executes filter after all actions except for passed actions' do
    
    end
  end
end
