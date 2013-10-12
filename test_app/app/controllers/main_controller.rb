class MainController < ApplicationController

  def index
    render :inline => 'Main#index', :layout => 'application'
  end

end
