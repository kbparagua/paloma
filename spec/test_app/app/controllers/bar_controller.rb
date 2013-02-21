class BarController < ApplicationController
  def basic_action
    render :inline => '<h1>Bar! Basic Action</h1>', :layout => 'application'
  end
end
