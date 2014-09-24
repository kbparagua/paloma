TestApp::Application.routes.draw do

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  root :to => 'main#index'

  resources :main, :controller => 'Main' do
    collection do
      get :prevent
      get :basic_params
      get :json_response
      get :js_response
      get :xml_response
      get :file_response
      get :rss_format, defaults: {format: :rss}
      get :json_format, defaults: {format: :json}
    end
  end


  namespace :admin do
    resources :foos
  end
end
