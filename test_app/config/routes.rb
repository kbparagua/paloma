TestApp::Application.routes.draw do

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  root :to => 'main#index'

  resources :main, :controller => 'Main'
  resources :foo, :controller => 'Foo'

  namespace :admin do
    resources :bar, :controller => 'Bar'
  end

end
