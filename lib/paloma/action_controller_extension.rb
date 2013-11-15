module Paloma


  module ActionControllerExtension

    def self.included base
      base.send :include, InstanceMethods
      base.send :extend, ClassMethods


      base.module_eval do
        prepend_view_path "#{Paloma.root}/app/views/"

        before_filter :track_paloma_request
        after_filter :append_paloma_hook, :if => :html_is_rendered?
      end
    end





    module ClassMethods

      #
      # Controller wide setting for Paloma.
      #

      def js path_or_options, params = {}
        @__paloma_settings = {:path_or_options => path_or_options, :params => params}
      end


      def paloma_settings
        @__paloma_settings
      end
    end





    module InstanceMethods

      #
      #
      # Specify the behavior of Paloma.
      #
      # Can call a different Controller or execute a different action, and
      # pass parameters.
      #
      # Usage:
      #
      #   js 'Controller', {params}
      #   js 'Controller#action', {params}
      #   js 'Namespace/Controller', {params}
      #   js 'Namespace/Controller#action', {params}
      #   js '#action', {params}
      #   js :action, {params}
      #   js :param_1 => 1, :param_2 => 2
      #
      #
      def js path_or_options, options = {:params => {}, :only => {}, :except => {}}
        options ||= {}

        # js false, options
        stop = self.try_paloma_stop(path_or_options, options) if !path_or_options
        return if stop


        if path_or_options.is_a? String
          path = path_or_options.split '#'
          resource = path.first
          action = path.length != 1 ? path.last : nil

          @__paloma_request[:resource] = resource unless resource.blank?
          @__paloma_request[:action] = action unless action.blank?

        elsif path_or_options.is_a? Symbol
          @__paloma_request[:action] = path_or_options

        elsif path_or_options.is_a? Hash
          self.set_paloma_params path_or_options[:params]
        end

        self.set_paloma_params options[:params] || {}
      end



      def try_paloma_stop path_or_options, options = {}
        current_action = @__paloma_request[:action]
        valid_action = true

        if options[:only].present?
          valid_action = options[:only].include?(current_action.to_sym) ||
                          options[:only].include?(current_action.to_s)
        end

        if options[:except].present?
          valid_action = !options[:except].include?(current_action.to_sym) ||
                          !options[:except].include?(current_action.to_s)
        end

        if valid_action
          @__paloma_request = nil
          return true
        end

        false
      end


      #
      # Executed every time a controller action is executed.
      #
      # Keeps track of what Rails controller/action is executed.
      #
      def track_paloma_request
        resource = controller_path.split('/').map(&:titleize).join('/').gsub(' ', '')

        @__paloma_request = {:resource => resource, :action => self.action_name}

        #
        # Apply controller wide settings if any
        #
        return if self.class.paloma_settings.nil?
        self.js self.class.paloma_settings[:path_or_options], self.class.paloma_settings[:params]
      end


      #
      # Before rendering html reponses,
      # this is exectued to append Paloma's html hook to the response.
      #
      # The html hook contains the javascript code that
      # will execute the tracked Paloma requests.
      #
      def append_paloma_hook
        return true if @__paloma_request.nil?

        hook = view_context.render(
                  :partial => 'paloma/hook',
                  :locals => {:request => @__paloma_request})

        before_body_end_index = response_body[0].rindex('</body>')

        # Append the hook after the body tag if it is present.
        if before_body_end_index.present?
          before_body = response_body[0][0, before_body_end_index].html_safe
          after_body = response_body[0][before_body_end_index..-1].html_safe

          response.body = before_body + hook + after_body
        else
          # If body tag is not present, append hook in the response body
          response.body += hook
        end

        @__paloma_request = nil
      end
    end


    def set_paloma_params params
      @__paloma_request[:params] ||= {}
      @__paloma_request[:params].merge! params
    end


    def html_is_rendered?
      not_redirect = self.status != 302
      [nil, 'text/html'].include?(response.content_type) && not_redirect
    end


    #
    # Make sure not to execute paloma on the following response type
    #
    def render options = nil, extra_options = {}, &block
      [:json, :js, :xml, :file].each do |format|
        js false if options.has_key?(format)
      end if options.is_a?(Hash)

      super
    end
  end


  ::ActionController::Base.send :include, ActionControllerExtension
end
