class MultipleNamesController < ApplicationController

  def index
    render :inline => 'MultipleName#index', :layout => 'application'
  end

end
