require 'action_controller/railtie'
require 'action_view/railtie'

# Database Configuration
ActiveRecord::Base.configurations = {'test' => {
  :adapter => 'sqlite3', 
  :database => ':memory:'}
}
ActiveRecord::Base.establish_connection('test')


# Dummy Rails Configurations
app = Class.new(Rails::Application)

app.config.secret_token = '3b7cd727ee24e8444053437c36cc66c4'
app.config.session_store :cookie_store, :key => '_myapp_session'
app.config.active_support.deprecation = :log
app.config.root = File.dirname(__FILE__)

Rails.backtrace_cleaner.remove_silencers!
app.initialize!

app.routes.draw do
  resources :articles
end


require 'models'
require 'controllers'
