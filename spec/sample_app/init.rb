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
  resources :articles, :controller => 'Articles'
end

require "#{Paloma.root}/spec/sample_app/model"
require "#{Paloma.root}/spec/sample_app/controllers"
