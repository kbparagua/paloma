require 'spec_helper'

feature 'Callbacks' do
  
  it 'should execute articles/new callback', :js => true do
    visit new_article_path  
    page.has_selector?('#from-articles-new-callback').should == true
  end


  it 'should execute callbacks for articles/create and articles/show', :js => true do
    visit new_article_path
    
    fill_in 'article[title]', :with => 'sexy paloma'
    fill_in 'article[body]', :with => 'sexy paloma body'
    click_button 'Save'
    
    page.has_selector?('#from-articles-create-callback').should == true
    page.has_selector?('#from-articles-show-callback').should == true
  end


  it 'should execute "new" callback instead of "create" after failed save', :js => true do
    visit new_article_path
    
    fill_in 'article[body]', :with => 'sexy paloma body'
    click_button 'Save'
  
    page.has_selector?('#from-articles-create-callback').should == false
    page.has_selector?('#from-articles-new-callback').should == true
  end
  
  
  it 'should have an access on the passed parameters on js_callback', :js => true do
    1.upto(30) do |i|
      Article.create :title => "Sexy Paloma #{i}", :body => "Sexy Body"
    end
    
    visit articles_path
    page.has_selector?('#article-count-30').should == true
  end
  
  
  it 'should not execute articles/update callback', :js => true do
    article = Article.create :title => "Sexy Paloma Baby!", :body => "OMG"
    
    visit edit_article_path(article)
    fill_in 'article[body]', :with => 'Updated Body'
    click_button 'Save'

    page.has_selector?('#from-articles-update-callback').should == false
    page.has_selector?('#from-articles-show-callback').should == true
  end
  
  
  it 'should execute articles/edit callback after failed update', :js => true do
    article = Article.create :title => 'Sexy Paloma Baby!', :body => 'Yeah'
    
    visit edit_article_path(article)
    fill_in 'article[title]', :with => ''
    click_button 'Save'
    
    page.has_selector?('#from-articles-edit-callback').should == true
  end
end
