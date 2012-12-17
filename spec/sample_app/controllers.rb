# Dummy Controllers
class ApplicationController < ActionController::Base
end


class ArticlesController < ApplicationController

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
      js_callback false
      render :new
    end
  end
  
end
