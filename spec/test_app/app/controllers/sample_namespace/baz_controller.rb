module SampleNamespace
  class BazController < ApplicationController
    def basic_action
      render :inline => 'SampleNamespace/Baz! Basic Action', :layout => 'application'
    end
    

    def another_basic_action
      render :inline => 'SampleNamespace/Baz! Another Basic Action', :layout => 'application'
    end


    def yet_another_basic_action
      render :inline => 'SampleNamespace/Baz! Yet Another Basic Action', :layout => 'application'
    end


    def callback_from_another_action
      js :basic_action
      render :inline => '<h1>Baz! Callback From Another action</h1>', :layout => 'application'
    end    
  end
end
