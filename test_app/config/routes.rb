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
      get :ajax
      get :multiple_calls_1
      get :multiple_calls_2
      get :multiple_calls_3
      get :multiple_calls_4
      get :multiple_calls_5
    end
  end


  namespace :admin do
    resources :foos
  end
end
