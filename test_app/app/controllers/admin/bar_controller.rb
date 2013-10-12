class Admin::BarController < ApplicationController

  def show
    render :inline => 'Admin/Bar#show', :layout => 'application'
  end

end
