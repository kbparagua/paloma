module Paloma

  # TODO explain!
  module ::ActionController::Redirecting
    alias_method :original_redirect_to, :redirect_to
  end

  

  module ActionControllerExtension
    def redirect_js_hook options = {}, response_status = {}
      add_to_callbacks @__paloma_callback__
      original_redirect_to options, response_status
    end      
    alias_method :redirect_to, :redirect_js_hook
    
    
    #
    # js false
    # js :new, :params => {}
    # js :controller => '', :action => '', :params => {}
    # js :params => {}
    #
    def js options = {}, extras = {}
      callback = {:controller => controller_path, :action => action_name}
      params = {}
      
      if options.is_a? Hash
        params = options[:params]
        callback = options[:controller].present? && options[:action].present? ? 
          {:controller => options[:controller], :action => options[:action]} :
          callback

      elsif options.is_a? Symbol
        params = extras[:params] 
        callback[:action] = options
      
      elsif options.is_a? FalseClass
        callback = nil
      end
      
      params ||= {}
      
      # Include request details
      params[:controller_path] = controller_path
      params[:action] = action_name
      
      @__paloma_callback__ = callback.present? ? callback.merge({:params => params}) : nil 
    end 
  end
  

  ::ActionController::Base.send :include, ActionControllerExtension
end
