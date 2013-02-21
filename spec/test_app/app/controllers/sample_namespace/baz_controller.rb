module SampleNamespace
  class BazController < ApplicationController
    def basic_action
      render :inline => 'SampleNamespace/Baz! Basic Action', :layout => 'application'
    end
    
    def callback_from_another_action
      js :controller => 'sample_namespace/baz', :action => 'basic_action'
      render :inline => '<h1>Baz! Callback From Another action</h1>', :layout => 'application'
    end
  end
end
