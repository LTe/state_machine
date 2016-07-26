module StateMachine
  module Event
    InvalidDefinition    = Class.new(StandardError)
    UnexpectedTransition = Class.new(StandardError)

    module ClassMethods
      attr_accessor :possible_transitions, :name

      def event(name, &block)
        self.name = name
        self.possible_transitions ||= {}
        self.possible_transitions[name] = {}

        if block_given?
          to = instance_eval(&block)
          return define_event_method(name, to)
        end

        raise InvalidDefinition
      end

      def transitions(options = {})
        from = Array(options[:from])
        to   = options[:to]

        raise InvalidDefinition if from.empty? && to.nil?

        possible_transitions[name][to] ||= []
        possible_transitions[name][to] += from
        possible_transitions[name][to].uniq!

        to
      end

    private

      def define_event_method(name, to)
        define_method("can_#{name}?") do
          self.class.possible_transitions[name][to].include?(state)
        end

        define_method("#{name}!") do
          return self.state = to if public_send("can_#{name}?")
          raise UnexpectedTransition
        end
      end
    end
  end
end
