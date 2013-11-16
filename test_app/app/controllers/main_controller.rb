class MainController < ApplicationController

  js false, :except => [:index]


  def index
    js :params => {:z => 2}
    render :inline => 'Main#index', :layout => 'application'
  end


  def json_response
    render :json => {:x => 1}
  end


  def js_response
    render :js => 'alert(1);'
  end


  def xml_response
    render :xml => '<xml></xml>'
  end


  def file_response
    render :file => "#{Rails.root}/Gemfile"
  end

end
