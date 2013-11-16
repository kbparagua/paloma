module Paloma
  class Utilities

    def self.get_resource controller_path
      controller_path.split('/').map(&:titleize).join('/').gsub(' ', '')
    end


    def self.interpret_route route_string = nil
      raise 'Empty route cannot be interpreted' if route_string.blank?

      parts = route_string.split '#'

      resource = parts.first
      resource = resource.blank? ? nil : resource

      action = parts.length != 1 ? parts.last : nil

      {:resource => resource, :action => action}
    end

  end
end