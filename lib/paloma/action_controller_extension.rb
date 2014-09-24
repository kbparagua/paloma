module Paloma


  module ActionControllerExtension

    def self.included base
      base.send :include, InstanceMethods
      base.send :extend, ClassMethods


      base.module_eval do
        prepend_view_path "#{Paloma.root}/app/views/"

        before_filter :track_paloma_request
        after_filter :append_paloma_hook, :if => :not_redirect?
      end
    end





    module ClassMethods

      #
      # Controller wide setting for Paloma.
      #

      def js path_or_options, options = {}
        options ||= {}

        scope = {}
        scope[:only] = options[:only] if options[:only]
        scope[:except] = options[:except] if options[:except]

        self.before_filter(
          Proc.new {
            self.js path_or_options, options[:params]
          },
          scope)
      end
    end





    module InstanceMethods

      #
      #
      # Specify the behavior of Paloma. Call this manually to override the
      # default Paloma controller/action to be executed.
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
      def js path_or_options, params = {}
        return self.paloma.clear_request if !path_or_options

        self.paloma.params.merge! params || {}

        #
        # 'Controller'
        # 'Controller#action'
        # 'Namespace/Controller'
        # 'Namespace/Controller#action'
        # '#action'
        #
        if path_or_options.is_a? String
          route = ::Paloma::Utilities.interpret_route path_or_options
          self.paloma.resource = route[:resource] unless route[:resource].blank?
          self.paloma.action = route[:action] unless route[:action].blank?

        # :action
        elsif path_or_options.is_a? Symbol
          self.paloma.action = path_or_options

        # :param_1 => 1, :param_2 => 2
        elsif path_or_options.is_a? Hash
          self.paloma.params.merge! path_or_options || {}

        end
      end


      #
      # Executed every time a controller action is executed.
      #
      # Keeps track of what Rails controller/action is executed.
      #
      def track_paloma_request
        self.paloma.resource ||= ::Paloma::Utilities.get_resource controller_path
        self.paloma.action ||= self.action_name
      end


      #
      # Before rendering html reponses,
      # this is exectued to append Paloma's html hook to the response.
      #
      # The html hook contains the javascript code that
      # will execute the tracked Paloma requests.
      #
      def append_paloma_hook
        return true if self.paloma.has_no_request?

        # Render the partial if it is present, otherwise do nothing. 
        return true unless lookup_context.exists?('paloma/_hook')

        hook = view_context.render(
                  :partial => 'paloma/hook',
                  :locals => {:request => self.paloma.request})

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

        self.paloma.clear_request
      end
    end


    def not_redirect?
      self.status != 302
    end


    #
    # Make sure not to execute paloma on the following response type
    #
    def render options = nil, extra_options = {}, &block
      [:json, :js, :xml, :file].each do |format|
        if options.has_key?(format)
          self.paloma.clear_request
          break
        end
      end if options.is_a?(Hash)

      super
    end


  protected

    def paloma
      @paloma ||= ::Paloma::Controller.new
    end

  end


  ::ActionController::Base.send :include, ActionControllerExtension
end
