module Paloma
  mattr_accessor :destination, :templates
  
  def self.root
    @paloma_root ||= "#{File.dirname(__FILE__)}/../"
  end
  
  
  def self.index_js
    @index_js ||= "#{Paloma.destination}/index.js"
  end
  
  
  def self.destination
    @destination ||= 'app/assets/javascripts/paloma'
  end
  
  
  def self.templates
    @templates ||= "#{Paloma.root}/app/templates"
  end
end

require 'action_controller/railtie'
require 'rails/generators'

# TODO: Rails version checking

require 'paloma/generators/add_generator'
require 'paloma/generators/setup_generator'
require 'paloma/action_controller_filters'
require 'paloma/action_controller_extension'
