require 'state_machine/version'
require 'state_machine/state'
require 'state_machine/event'

module StateMachine
  include State
  include Event

  def self.included(base)
    base.extend(State::ClassMethods)
    base.extend(Event::ClassMethods)
  end
end
