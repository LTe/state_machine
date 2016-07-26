module StateMachine
  module Event
    module ClassMethods
      def event(name)
        define_event_method(name)
      end

    private

      def define_event_method(name)
        define_method("#{name}!") do

        end
      end
    end
  end
end
