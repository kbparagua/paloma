module Paloma
  module ActionControllerFilters
    
    def self.included base
      base.module_eval do
        before_filter :js_callback
        after_filter :update_callback, :if => :html_response_from_render?
      end
    end

    
  protected
    
    def html_response_from_render?
      [nil, 'text/html'].include?(response.content_type) && self.status != 302 
    end

        
    def update_callback
      add_to_callbacks @__callback__, @__js_params__
      
      response_body[0] += view_context.render(
        :file => "#{Paloma.root}/app/views/paloma/callback_hook",
        :locals => {:callbacks => session[:callbacks]})
      
      response.body = response_body[0]
      clear_callbacks
    end
    
    
    def add_to_callbacks name, params
      session[:callbacks] ||= []
      session[:callbacks].push({:name => name, :params => params})
    end
    
    
    def get_callbacks
      session[:callbacks]
    end
    
    
    def clear_callbacks
      session[:callbacks] = []
    end
  
  end
  
  
  ::ActionController::Base.send :include, ActionControllerFilters
end
