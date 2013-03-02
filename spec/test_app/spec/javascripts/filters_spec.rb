require 'spec_helper'

describe 'Paloma.FilterScope', :type => :feature, :js => true do  
  
  shared_context 'paths-' do
    let(:basic_action) { basic_action_bar_path }
    let(:another_basic_action) { another_basic_action_bar_path }
    let(:yet_another_basic_action) { yet_another_basic_action_bar_path}
  end
  
  shared_context 'paths-Application' do
    include_context 'paths-'
  end
  
  shared_context 'paths-Namespaced' do
    let(:basic_action) { basic_action_sample_namespace_baz_path }
    let(:another_basic_action) { another_basic_action_sample_namespace_baz_path }
    let(:yet_another_basic_action) { yet_another_basic_action_sample_namespace_baz_path }  
  end
    
  
  
  shared_examples 'standard' do |options|
    type = options[:type]
    name = options[:name]
    method = options[:method] || "##{type}"
    scope = parse_scope options[:scope]
    filter =  "#{scope}Standard #{name}"
  
    describe method do
      it "executes filter #{type} callbacks for the passed actions" do
        visit basic_action
        page.evaluate_script("filtersExecuted.#{type}").should include filter
      end

      it "does not execute filter #{type} callbacks for other actions" do
        visit yet_another_basic_action
        page.evaluate_script("filtersExecuted.#{type}").should_not include filter
      end
    end
  end
  
  
  shared_examples 'all' do |options|
    type = options[:type]
    name = options[:name]
    method = options[:method] || "##{type}_all"
    scope = parse_scope options[:scope]
    filter = "#{scope}#{name} All"

    describe method do
      it "executes filter #{type} callbacks on all actions" do
        visit basic_action
        page.evaluate_script("filtersExecuted.#{type}").should include filter
      end      
    end    
  end
  
  
  shared_examples 'except' do |options|
    type = options[:type]
    name = options[:name]
    method = options[:method] || "#except_#{type}"
    scope = parse_scope options[:scope]
    filter = "#{scope}Except #{name}"
    
    describe method do
      it "executes filter #{type} callback on all actions except for passed actions" do
        visit another_basic_action
        page.evaluate_script("filtersExecuted.#{type}").should include filter
      end

      it "does not execute filter #{type} callback on passed actions" do
        visit basic_action
        page.evaluate_script("filtersExecuted.#{type}").should_not include filter
      end
    end
  end
  
  
  shared_examples 'filter subtypes' do |options|
    params = {:type => options[:type], 
      :name => options[:type].titleize, 
      :scope => options[:scope]}
    
    include_examples 'standard', params
    include_examples 'all', params
    include_examples 'except', params
  end
  
  
  shared_examples 'filters' do |scope|
    context "when inside the scope of #{scope}" do
      include_context "paths-#{scope}"
    
      def self.parse_scope scope
        scope.blank? ? scope : "#{scope} "
      end

      # Before and After Filters
      include_examples 'filter subtypes', {:type => 'before', :scope => scope}
      include_examples 'filter subtypes', {:type => 'after', :scope => scope}
      
      # Around Filters
      include_examples 'standard', {:name => 'Around', 
        :type => 'before', 
        :method => '#around', 
        :scope => scope} 
      
      include_examples 'standard', {:name => 'Around',
        :type => 'after', 
        :method => '#around', 
        :scope => scope}
      
      include_examples 'all', {:name => 'Around', 
        :type => 'before', 
        :method => '#around_all', 
        :scope => scope}
      
      include_examples 'all', {:name => 'Around',
        :type => 'after', 
        :method => '#around_all',
        :scope => scope}
      
      include_examples 'except', {:name => 'Around', 
        :type => 'before', 
        :method => '#except_around', 
        :scope => scope}
      
      include_examples 'except', {:name => 'Around',
        :type => 'after', 
        :method => '#except_around', 
        :scope => scope}
    end
  end



  shared_examples 'skip filters' do |type|
    name = type.titleize
    filter = "- Skip This #{name} Filter"

    describe "#skip_#{type}_filter" do
      context 'when not appended with #only or #expect' do
        it "skips passed #{type} filters for all actions" do
          visit basic_action_sample_namespace_baz_path
          page.evaluate_script("filtersExecuted.#{type}").should_not include "All #{filter}"
        end
      end

      context 'with #only' do
        it "skips passed #{type} filters for actions passed on #only" do
          visit another_basic_action_sample_namespace_baz_path
          page.evaluate_script("filtersExecuted.#{type}").should_not include "Only #{filter}"
        end

        it "performs passed #{type} filters for actions not passed on #only" do
          visit basic_action_sample_namespace_baz_path
          page.evaluate_script("filtersExecuted.#{type}").should include "Only #{filter}"
        end
      end

      context 'with #except' do
        it "skips passed #{type} filters for actions not passed on #except" do
          visit yet_another_basic_action_sample_namespace_baz_path
          page.evaluate_script("filtersExecuted.#{type}").should_not include "Except #{filter}"
        end

        it "performs passed #{type} filters for actions passed on #except" do
          visit another_basic_action_sample_namespace_baz_path
          page.evaluate_script("filtersExecuted.#{type}").should include "Except #{filter}"
        end
      end
    end  
  end



  # Testing starts here
  include_examples 'filters', ''            # non-namespaced filters
  include_examples 'filters', 'Namespaced'   # namespaced filters
  include_examples 'filters', 'Application' # application-wide filters

  #include_examples 'skip filters', 'before'
  #include_examples 'skip filters', 'after'
  #include_examples 'skip filters', 'around'
end
