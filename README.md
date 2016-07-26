# StateMachine

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'state_machine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install state_machine

## Development

To run test execute `rake`.

`Coverage report generated for RSpec to /Users/lite/work/state_machine/coverage. 199 / 199 LOC (100.0%) covered.`

## Usage

```ruby
class MovementState
  include StateMachine

  state :standing, initial: true
  state :walking
  state :running

  event :walk do
    transitions from: :standing, to: :walking
  end

  event :run do
    transitions from: [:standing, :walking], to: :running, when: proc { heavy_method }
  end

  event :hold do
    transitions from: [:walking, :running], to: :standing, when: :heavy_method
  end

  def heavy_method
    true
  end
end

movement_state = MovementState.new
movement_state.walk!
movement_state.walking? # => true
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

