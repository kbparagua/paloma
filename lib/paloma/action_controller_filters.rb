module Paloma
  module ActionControllerFilters
    
    def self.included base
      base.module_eval do
        prepend_view_path "#{Paloma.root}/app/views/"
        before_filter :js_callback
        after_filter :update_callback, :if => :html_response_from_render?
      end
    end

    
  protected
    
    def html_response_from_render?
      [nil, 'text/html'].include?(response.content_type) && self.status != 302 
    end

        
    def update_callback
      add_to_callbacks @__paloma_callback__

      paloma_txt = view_context.render(
        :partial => "paloma/callback_hook",
        :locals => {:callbacks => session[:callbacks]})
      
      before_body_end_index = response_body[0].rindex('</body>')
      
      if before_body_end_index.present?
        before_body_end_content = response_body[0][0, before_body_end_index].html_safe
        after_body_end_content = response_body[0][before_body_end_index..-1].html_safe
        
        response_body[0] = before_body_end_content + paloma_txt + after_body_end_content
       
        response.body = response_body[0]
      else
        # If body tag is not present, append paloma_txt in the response body
        response_body[0] += paloma_txt
        response.body = response_body[0]
      end
      
      clear_callbacks
    end
    
    
    def add_to_callbacks callback
      return true if callback.nil?
      session[:callbacks] ||= []
      session[:callbacks].push(callback)
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


