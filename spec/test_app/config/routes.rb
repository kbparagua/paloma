TestApp::Application.routes.draw do
  
  resource :foo, :controller => 'Foo' do
    collection do
      get :basic_action
      get :callback_from_another_action
      get :callback_from_another_controller
      get :callback_from_namespaced_controller
      get :skip_callback
    end
  end
  
  resource :bar, :controller => 'bar' do
    collection do
      get :basic_action
      get :different_params
      get :another_basic_action
      get :yet_another_basic_action
    end
  end
  
  namespace :sample_namespace do
    resource :baz, :controller => 'baz' do
      collection do
        get :basic_action
        get :callback_from_another_action
      end
    end
  end

end
