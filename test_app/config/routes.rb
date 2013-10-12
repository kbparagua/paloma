TestApp::Application.routes.draw do

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  root :to => 'main#index'
end
