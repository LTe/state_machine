require 'spec_helper'

RSpec.describe StateMachine::Event do
  let(:test_class) { Class.new { include StateMachine } }

  context ".event" do
    before do
      test_class.state :standing, initial: true
      test_class.state :walking
      test_class.state :running
    end

    subject { test_class.new }

    context "invalid definition" do
      context "no block" do
        it "raises an exception" do
          expect { test_class.event :walk }.to raise_error(StateMachine::Event::InvalidDefinition)
        end
      end

      context "invalid paramters" do
        it "raises an exception" do
          expect do
            test_class.event :walk do
              transitions from: []
            end
          end.to raise_error(StateMachine::Event::InvalidDefinition)
        end
      end
    end

    context "definition with transition" do
      it "change state to value given in `:to` key" do
        test_class.event :walk do
          transitions from: :standing, to: :walking
        end

        subject.walk!
        expect(subject.walking?).to be_truthy
      end

      it "does not allow to unallowed transition" do
        test_class.event :run do
          transitions from: :walking, to: :running
        end

        expect { subject.run! }.to raise_error(StateMachine::Event::UnexpectedTransition)
      end

      it "allows to define many `from`s" do
        test_class.event :sonic do
          transitions from: [:standing, :running], to: :running
        end

        subject.sonic!
        expect(subject.running?).to be_truthy
      end
    end
  end

  context ".can_*?" do
    subject { test_class.new }

    before do
      test_class.state :standing, initial: true
      test_class.state :walking
      test_class.state :running

      test_class.event :walk do
        transitions from: :standing, to: :walking
      end

      test_class.event :run do
        transitions from: :walking, to: :running
      end

      test_class.event :sonic do
        transitions from: [:standing, :running], to: :running
      end
    end

    context "#can_{transition}?" do
      context "allowed transition" do
        it "returns true" do
          expect(subject.can_walk?).to be_truthy
        end
      end

      context "unallowed transition" do
        it "returns false" do
          expect(subject.can_run?).to be_falsey
        end
      end
    end
  end
end
