module Paloma

  # TODO explain!
  module ::ActionController::Flash
    alias_method :original_redirect_to, :redirect_to
  end



  module ActionControllerExtension

    def self.included base
      base.module_eval do
        prepend_view_path "#{Paloma.root}/app/views/"

        # Enable paloma on all controller action by default
        before_filter :js

        after_filter :update_callback, :if => :html_response_from_render?
      end
    end





  protected



    # Save
    def redirect_js_hook options = {}, response_status_and_flash = {}
      push_current_callback
      original_redirect_to options, response_status_and_flash
    end
    alias_method :redirect_to, :redirect_js_hook


    #
    # js false
    # js :new, :params => {}
    # js :resource => 'Namespace.Resource', :action => 'testAction', :params => {}
    # js :params => {}
    #
    def js options = {}, extras = {}
      # default resource
      resource_name = controller_path.split('/').map(&:titleize).join('.')
      callback = {:resource => resource_name, :action => self.parse_action, :params => {}}

      if options.is_a? Hash
        callback = options if options[:resource].present? && options[:action].present?

      elsif options.is_a? Symbol
        callback[:action] = self.parse_action(options)

      elsif options.is_a? FalseClass
        callback = nil
      end

      # Include rails request details
      if callback.present?
        controller_detail = controller_path.split('/')
        callback[:params][:rails] = {:controller => controller_detail.pop,
                                      :namespace => controller_detail.pop,
                                      :action => self.action_name,
                                      :controllerPath => self.controller_path}
      end

      self.current_callback = callback
    end


    def html_response_from_render?
      [nil, 'text/html'].include?(response.content_type) && self.status != 302
    end


    def update_callback
      return clear_callbacks if self.current_callback.nil?

      push_current_callback

      paloma_txt = view_context.render(
                      :partial => "paloma/callback_hook",
                      :locals => {:callbacks => self.callbacks})


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


    def push_current_callback
      session[:callbacks] ||= []
      session[:callbacks].push(self.current_callback) if self.current_callback.present?
    end


    def callbacks
      session[:callbacks]
    end


    def clear_callbacks
      session[:callbacks] = []
    end


    def current_callback= callback
      @__paloma_callback__ = callback
    end


    def current_callback
      @__paloma_callback__
    end


    def parse_action action
      action ||= self.action_name
      action.split('_').map(&:titleize).join
    end

  end


  ::ActionController::Base.send :include, ActionControllerExtension
end
