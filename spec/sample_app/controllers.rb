# Dummy Controllers
class ApplicationController < ActionController::Base
end


class FooController < ApplicationController
  def basic_action
  end

  def callback_from_another_action
    js_callback :basic_action
    render :inline => '<h1>Foo! Callback From Another Action</h1>', :layout => 'application'
  end
  
  def callback_from_another_controller
    js_callback :controller => 'baz', :action => 'basic_action'
  end
end



class BarController < ApplicationController
  def basic_action
  end
end



module SampleNamespace
  class BazController < ApplicationController
    def basic_action
    end
    
    def callback_from_another_action
      js_callback :cotroller => 'sample_namespace/baz', :action => 'basic_action'
      render :inline => '<h1>Baz! Callback From Another action</h1>', :layout => 'application'
    end
  end
end
