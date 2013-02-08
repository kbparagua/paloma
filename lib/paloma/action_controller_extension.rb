module Paloma

  # TODO explain!
  module ::ActionController::Redirecting
    alias_method :original_redirect_to, :redirect_to
  end

  

  module ActionControllerExtension
    def redirect_js_hook options = {}, response_status = {}
      add_to_callbacks @__callback__, @__js_params__
      original_redirect_to options, response_status
    end      
    alias_method :redirect_to, :redirect_js_hook
    
    
    #
    # js_callback false
    # js_callback :new, :params => {}
    # js_callback :controller => '', :action => '', :params => {}
    # js_callback :params => {}
    #
    def js_callback options = {}, extras = {}
      default_callback = "#{controller_path}/#{action_name}"
      params = {}
      
      if options.is_a? Hash
        params = options[:params]
        callback = options[:controller].present? && options[:action].present? ? 
          "#{options[:controller]}/#{options[:action]}" :
          default_callback

      elsif options.is_a? Symbol
        params = extras[:params] 
        callback = "#{controller_path}/#{options}"
      
      elsif options.nil? || options.is_a?(TrueClass)
        callback = default_callback
      
      else # false
        callback = nil
      end
      
      
      params ||= {}
      params[:controller] = controller_path.to_s
      params[:action] = action_name.to_s
      
      @__callback__ = callback
      @__js_params__ = params
    end 
  end
  

  ::ActionController::Base.send :include, ActionControllerExtension
end
