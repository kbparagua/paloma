# Dummy Controllers
class ApplicationController < ActionController::Base
end


class ArticlesController < ApplicationController

  def index
    @articles = Article.all
    js_callback :params => {:article_count => @articles.size}
  end
  

  def show
    @article = Article.find params[:id]
  end
  
  
  def new
    @article = Article.new
  end
  
  
  def create
    @article = Article.new params[:article]
       
    if @article.save
      redirect_to @article
    else
      js_callback :new
      render :new
    end
  end
  
  
  def edit
    @article = Article.find params[:id]
    render :new
  end
  
  
  def update
    @article = Article.find params[:id]
    
    if @article.update_attributes params[:article]
      js_callback false
      redirect_to @article
    else
      js_callback :controller => :articles, :action => :edit
      render :new
    end
  end
  
end
