class Admin::FoosController < ApplicationController

  # Default behavior
  def index
    render :inline => 'Admin/Foos#index', :layout => 'application'
  end


  # Override controller
  def show
    js 'NotAdmin/Foos', :x => 99
    render :inline => 'Admin/Foos#show', :layout => 'application'
  end


  # Override action
  def new
    js '#otherAction', :x => 99
    render :inline => 'Admin/Foos#new', :layout => 'application'
  end


  # Override controller/action
  def edit
    js 'NotAdmin/Foos#otherAction', :x => 99
    render :inline => 'Admin/Foos#edit', :layout => 'application'
  end

end
