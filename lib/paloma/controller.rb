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