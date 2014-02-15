class BarsController < ApplicationController

  def index
    render :inline => 'Bars#index', :layout => 'application'
  end

end