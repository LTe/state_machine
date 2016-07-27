class Example
  include StateMachine

  state :standing, initial: true
  state :walking
  state :running
  state :supersonic

  event :walk do
    transitions from: :standing, to: :walking
  end

  event :run do
    transitions from: :walking, to: :running
  end

  event :sonic do
    transitions from: [:standing, :walking], to: :supersonic
  end

  event :stop do
    transitions from: [:supersonic, :running, :walking], to: :standing
  end
end
