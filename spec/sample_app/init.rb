require 'action_controller/railtie'
require 'action_view/railtie'

require 'jquery-rails'
require 'sprockets/railtie'
require 'sprockets'


# Dummy Rails Configurations
app = Class.new(Rails::Application)
app.config.secret_token = '3b7cd727ee24e8444053437c36cc66c4'
app.config.session_store :cookie_store, :key => '_myapp_session'
app.config.active_support.deprecation = :log
app.config.root = File.dirname(__FILE__)

# Assets
app.config.assets.enabled = true
app.config.assets.version = '1.0'
app.config.assets.compress = false
app.config.assets.debug = true
app.config.assets.compile = true

Rails.backtrace_cleaner.remove_silencers!
app.initialize!


# Routes
app.routes.draw do
  resource :foo, :controller => 'Foo' do
    collection do
      get :basic_action
      get :callback_from_another_action
      get :callback_from_another_controller
      get :callback_from_namespaced_controller
    end
  end
  
  
  resource :bar, :controller => 'bar' do
    collection do
      get :basic_action
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


require "#{Paloma.root}/spec/sample_app/models"
require "#{Paloma.root}/spec/sample_app/controllers"
