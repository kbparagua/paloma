class FooController < ApplicationController

  def index
    redirect_to main_index_path
  end

  def show
    js :parameter => 'Parameter From Paloma'
    render :inline => '<h1>Foo#show</h1>', :layout => 'application'
  end

end
