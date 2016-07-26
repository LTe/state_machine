require 'spec_helper'

RSpec.describe "StateMachine guards" do
  subject { test_class.new }

  let(:test_class) do
    Class.new do
      include StateMachine

      attr_accessor :guard

      state :standing, initial: true
      state :walking
      state :running

      event :walk do
        transitions from: :standing, to: :walking, when: proc { false }
      end

      event :sonic do
        transitions from: [:standing, :walking], to: :running, when: :guard
      end
    end
  end

  context "proc" do
    context "guard is false" do
      it "raises UnexpectedTransition" do
        expect { subject.walk! }.to raise_error(StateMachine::Event::UnexpectedTransition)
      end
    end

    context "guard is true" do
      before do
        test_class.event :walk do
          transitions from: :standing, to: :walking, when: proc { true }
        end
      end

      it "changes state to walking" do
        subject.walk!
        expect(subject.walking?).to be_truthy
      end
    end
  end

  context "method name" do
    context "executes method as guard" do
      context "guard is true" do
        before { subject.guard = true }

        it "executes transition" do
          subject.sonic!
          expect(subject.running?).to be_truthy
        end
      end

      context "guard is false" do
        before { subject.guard = false }

        it "raises an error" do
          expect { subject.sonic! }
            .to raise_error(StateMachine::Event::UnexpectedTransition)
        end
      end
    end
  end
end
