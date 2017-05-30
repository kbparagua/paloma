module Paloma


  module ActionControllerExtension

    def self.included base
      base.send :include, InstanceMethods
      base.send :extend, ClassMethods


      base.module_eval do
        prepend_view_path "#{Paloma.root}/app/views/"

        before_action :track_paloma_request
        helper_method :insert_paloma_hook
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

        self.before_action(
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
      # NOTE:
      # Calling this more than once in a single action will not clear
      # the previous config from the previous call.
      #
      # Example:
      # def new
      #   js 'MyController#new'
      #   js :edit
      #   js :x => 1, :y => 2
      #
      #   # Paloma will execute JS for
      #   # MyController#edit and will pass the parameters :x => 1, :y => 2
      # end
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
      #   js true
      #   js false
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
          self.paloma.resource = route[:resource] if route[:resource].present?
          self.paloma.action = route[:action] if route[:action].present?

        # :action
        elsif path_or_options.is_a? Symbol
          self.paloma.action = path_or_options

        # :param_1 => 1, :param_2 => 2
        elsif path_or_options.is_a? Hash
          self.paloma.params.merge! path_or_options || {}

        elsif path_or_options != true
          raise "Paloma: Invalid argument (#{path_or_options}) for js method"
        end

        self.paloma.resource ||= self.default_resource
        self.paloma.action ||= self.default_action
      end


      #
      # Executed every time a controller action is executed.
      #
      # Keeps track of what Rails controller/action is executed.
      #
      def track_paloma_request
        self.paloma.resource ||= self.default_resource
        self.paloma.action ||= self.default_action
      end


      #
      # Call in your view to insert Paloma's html hook.
      #
      # The html hook contains the javascript code that
      # will execute the tracked Paloma requests.
      #
      def insert_paloma_hook
        return nil if self.paloma.has_no_request?

        hook = view_context.render(
                 :partial => 'paloma/hook',
                 :locals => {:request => self.paloma.request})

        self.paloma.clear_request
        hook
      end
    end





  protected

    def paloma
      @paloma ||= ::Paloma::Controller.new
    end


    def default_resource
      ::Paloma::Utilities.get_resource self.controller_path
    end


    def default_action
      self.action_name
    end

  end


  ::ActionController::Base.send :include, ActionControllerExtension
end
