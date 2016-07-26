module StateMachine
  module State
    InitialStateAlreadyDefined = Class.new(StandardError)
    DoubleStateDefinition      = Class.new(StandardError)

    attr_accessor :state

    def initialize(*)
      super
      @state = self.class.initial_state
    end

    module ClassMethods
      attr_accessor :states, :initial_state

      def state(state, options = {})
        raise InitialStateAlreadyDefined if options[:initial] && initial_state
        raise DoubleStateDefinition      if (states || []).include?(state)

        self.states ||= []
        self.states << state
        self.states.uniq!

        self.initial_state = state if options[:initial]

        define_state_method(state)
      end

    private

      def define_state_method(name)
        define_method("#{name}?") do
          @state == name
        end
      end
    end
  end
end
