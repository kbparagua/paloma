class MainController < ApplicationController

  # Default behavior
  def index
    render :inline => 'Main#index', :layout => 'application'
  end


  # Override controller
  def show
    js 'OtherMain', :x => 1
    render :inline => 'Main#show', :layout => 'application'
  end


  # Override action
  def new
    js :otherAction, :x => 1
    render :inline => 'Main#new', :layout => 'application'
  end


  # Override controller/action
  def edit
    js 'OtherMain#otherAction', :x => 1
    render :inline => 'Main#edit', :layout => 'application'
  end


  # Stop paloma from execution
  def prevent
    js false
    render :inline => 'Main#prevent', :layout => 'application'
  end


  def basic_params
    js :x => 1, :y => 2
    render :inline => 'Main#basic_params', :layout => 'application'
  end


  def ajax
    render :ajax, :layout => false
  end





  #
  # Non-HTML response
  #

  def json_response
    render :json => {:x => 1}
  end


  def js_response
    render :js => 'alert(1);'
  end


  def xml_response
    render :xml => '<?xml version="1.0" encoding="UTF-8"?><note>test</note>'
  end


  def file_response
    render :file => "#{Rails.root}/Gemfile", :layout => false
  end

end
