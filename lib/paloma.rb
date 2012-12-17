module Paloma
  def self.root
    @paloma_root ||= File.dirname(__FILE__) + '/../'
  end
end

require 'rails/all'

# TODO: Rails version checking

require 'paloma/paloma_generator'
require 'paloma/action_controller_filters'
require 'paloma/action_controller_extension'
