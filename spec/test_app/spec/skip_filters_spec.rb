require 'spec_helper'


describe 'Skip Filter', :type => :feature, :js => true do

  def filters_executed type
    page.evaluate_script("filtersExecuted.#{type}")
  end


  shared_examples 'skip_*_filter/s' do |execution, name|

    describe "#skip_#{name}_filter/s" do
      context "with no inclusion method called" do
        it "skips the #{name} filters" do
          visit basic_action_bar_path
          filters_executed(execution).should_not include "Standard Skip #{name.titleize} Filter"
        end
      end


      context "with #only inclusion method called" do
        filter = "Only Skip #{name.titleize} Filter"
        
        it "skips the #{name} filters for the actions passed" do
          visit basic_action_bar_path
          filters_executed(execution).should_not include filter
        end

        it "does not skip the #{name} filters for the other actions" do
          visit another_basic_action_bar_path
          filters_executed(execution).should include filter
        end
      end


      context "with #except inclusion method called" do
        filter = "Except Skip #{name.titleize} Filter"
        
        it "skips the #{name} filters for the actions which are not passed" do
          visit basic_action_bar_path
          filters_executed(execution).should_not include filter
        end

        it "does not skip the #{name} filters for the actions passed" do
          visit yet_another_basic_action_bar_path
          filters_executed(execution).should include filter
        end
      end
    end
  end


  include_examples 'skip_*_filter/s', 'before', 'before'
  include_examples 'skip_*_filter/s', 'after', 'after'
  include_examples 'skip_*_filter/s', 'before', 'around'
  include_examples 'skip_*_filter/s', 'after', 'around'
end