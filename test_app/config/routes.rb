TestApp::Application.routes.draw do

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  root :to => 'main#index'

  resources :main, :controller => 'Main' do
    member do
      get :json_response
      get :js_response
      get :xml_response
      get :file_response
    end
  end

  resources :foo, :controller => 'Foo'

  namespace :admin do
    resources :bar, :controller => 'Bar'
  end


  resources :multiple_names
end
