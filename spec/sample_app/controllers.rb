# Dummy Controllers
class ApplicationController < ActionController::Base
end


class FooController < ApplicationController
  def basic_action
    render :inline => '<h1>Foo! Basic Action</h1>', :layout => 'application'
  end

  def callback_from_another_action
    js_callback :basic_action
    render :inline => '<h1>Foo! Callback From Another Action</h1>', :layout => 'application'
  end
  
  def callback_from_another_controller
    js_callback :controller => 'bar', :action => 'basic_action'
    render :inline => '<h1>Foo! Callback From Another Controller</h1>', :layout => 'application'
  end
  
  def skip_callback
    js_callback false
    render :inline => '<h1>Foo! Skip Callback</h1>', :layout => 'application'
  end
  
  def callback_from_namespaced_controller
    js_callback :controller => 'sample_namespace/baz', :action => 'basic_action'
    render :inline => '<h1>Foo! Callback From Namespaced Controller</h1>', :layout => 'application'
  end
end



class BarController < ApplicationController
  def basic_action
    render :inline => '<h1>Bar! Basic Action</h1>', :layout => 'application'
  end
end



module SampleNamespace
  class BazController < ApplicationController
    def basic_action
      render :inline => 'SampleNamespace/Baz! Basic Action', :layout => 'application'
    end
    
    def callback_from_another_action
      js_callback :controller => 'sample_namespace/baz', :action => 'basic_action'
      render :inline => '<h1>Baz! Callback From Another action</h1>', :layout => 'application'
    end
  end
end
