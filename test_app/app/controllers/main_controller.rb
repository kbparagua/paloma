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


  def multiple_calls_1
    js false
    js :x => 70
    render :inline => 'Main#multiple_calls', :layout => 'application'
  end


  def multiple_calls_2
    js false
    js 'OtherMain'
    render :inline => 'Main#multiple_calls_2', :layout => 'application'
  end


  def multiple_calls_3
    js 'OtherMain'
    js :show
    render :inline => 'Main#multiple_calls_3', :layout => 'application'
  end


  def multiple_calls_4
    js 'OtherMain#show'
    js false
    render :inline => 'Main#multiple_calls_4', :layout => 'application'
  end


  def multiple_calls_5
    js false
    js true
    render :inline => 'Main#multiple_calls_5', :layout => 'application'
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
