module Paloma
  class Settings

    attr_accessor :path_or_options, :params, :only, :except



    def initialize
      self.path_or_options = nil
      self.params = {}
    end


    def has_values?
      !self.path_or_options.nil? || !self.params.nil?
    end


    def set_scope scope = nil
      self.scope = scope
    end


    def in_scope? action
      return true if self.scope.blank?

      included = false
      only = self.scope[:only]
      except = self.scope[:except]

      if only.present?
        included = only.include?(action.to_s) ||
                    only.include?(action.to_sym)
      end

      if except.present?
        included = !(except.include?(action.to_s) ||
                    except.include?(action.to_sym))
      end

      included
    end

  end
end