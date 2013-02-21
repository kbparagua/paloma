class FooController < ApplicationController
  def basic_action
    render :inline => '<h1>Foo! Basic Action</h1>', :layout => 'application'
  end

  def callback_from_another_action
    js :basic_action
    render :inline => '<h1>Foo! Callback From Another Action</h1>', :layout => 'application'
  end
  
  def callback_from_another_controller
    js :controller => 'bar', :action => 'basic_action'
    render :inline => '<h1>Foo! Callback From Another Controller</h1>', :layout => 'application'
  end
  
  def skip_callback
    js false
    render :inline => '<h1>Foo! Skip Callback</h1>', :layout => 'application'
  end
  
  def callback_from_namespaced_controller
    js :controller => 'sample_namespace/baz', :action => 'basic_action'
    render :inline => '<h1>Foo! Callback From Namespaced Controller</h1>', :layout => 'application'
  end
end
