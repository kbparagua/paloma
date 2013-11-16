module Paloma
  class Controller

    attr_accessor :resource, :action, :params



    def initialize
      self.clear_request
    end


    def clear_request
      self.resource = nil
      self.action = nil
      self.params = {}

      true
    end


    def attempt_clear_request! options = {:only => {}, :except => {}}
      return self.clear_request if options.blank?

      clear = true
      only = options[:only]
      except = options[:except]

      if only.present?
        clear = only.include?(self.action.to_s) ||
                only.include?(self.action.to_sym)
      end

      if except.present?
        clear = !(except.include?(self.action.to_s) ||
                except.include?(self.action.to_sym))
      end

      return self.clear_request if clear

      false
    end


    def request
      {:resource => self.resource, :action => self.action, :params => self.params}
    end


    def has_request?
      self.resource.present? && self.action.present?
    end


    def has_no_request?
      !self.has_request?
    end


  end
end