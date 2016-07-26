module StateMachine
  module Event
    InvalidDefinition    = Class.new(StandardError)
    UnexpectedTransition = Class.new(StandardError)

    module ClassMethods
      attr_accessor :possible_transitions, :name, :guards

      def event(name, &block)
        self.name = name
        self.possible_transitions       ||= {}
        self.guards                     ||= {}
        self.guards[name]               = {}
        self.possible_transitions[name] = {}

        if block_given?
          to = instance_eval(&block)
          return define_event_method(name, to)
        end

        raise InvalidDefinition
      end

      def transitions(options = {})
        from  = Array(options[:from])
        to    = options[:to]
        guard = options[:when] || proc { true }

        if from.empty? && to.nil? || !((from + [to]) - states).empty?
          raise InvalidDefinition
        end

        guards[name][to] = guard
        possible_transitions[name][to] ||= []
        possible_transitions[name][to] += from
        possible_transitions[name][to].uniq!

        to
      end

    private

      def define_event_method(name, to)
        define_method("can_#{name}?") do
          self.class.possible_transitions[name][to].include?(state) &&
            instance_eval(&self.class.guards[name][to])
        end

        define_method("#{name}!") do
          if public_send("can_#{name}?")
            state.tap do |state|
              public_send("before_#{name}") if respond_to?("before_#{name}")
              public_send("enter_#{to}")    if respond_to?("enter_#{to}")
              self.state = to
              public_send("leave_#{state}") if respond_to?("leave_#{state}")
              public_send("after_#{name}")  if respond_to?("after_#{name}")
            end

            return
          end

          raise UnexpectedTransition
        end
      end
    end
  end
end
