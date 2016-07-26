require 'spec_helper'

RSpec.describe StateMachine::Event do
  let(:test_class) { Class.new { include StateMachine } }

  context ".event" do
    before { test_class.state :standing, initial: true }

    subject { test_class.new }

    it "defines event" do
      test_class.event :walk

      expect { subject.walk! }.not_to raise_error(NoMethodError)
    end
  end
end
