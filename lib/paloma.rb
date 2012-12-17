module Paloma
  def self.root
    @paloma_root ||= File.dirname(__FILE__) + '/../'
  end
end


# TODO: Rails version checking

require 'paloma/action_controller_filters'
require 'paloma/action_controller_extensions'
