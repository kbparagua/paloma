module Paloma
  def self.root
    @paloma_root ||= File.dirname(__FILE__) + '/../'
  end
end

require 'action_controller/railtie'
require 'rails/generators'

# TODO: Rails version checking

require 'paloma/callback_generator'
require 'paloma/action_controller_filters'
require 'paloma/action_controller_extension'
