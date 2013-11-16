module Paloma
  def self.root
    @paloma_root ||= "#{File.dirname(__FILE__)}/../"
  end
end

# TODO: Rails version checking

require 'action_controller/railtie'
require 'paloma/controller'
require 'paloma/utilities'
require 'paloma/action_controller_extension'
require 'paloma/rails/engine'
