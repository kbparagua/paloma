require 'spec_helper'

describe "Rendering HTML response of controller's action ", :type => :feature do
  
  it "executes the correct javascript callback" do
    visit new_article_path      
    
    page.has_css?('.callback-details').should == true
  end
  
end
