require 'spec_helper'

RSpec.describe StateMachine::State do
  let(:test_class) { Class.new { include StateMachine } }

  context ".state" do
    context "state define" do
      before { test_class.state :standing }

      it "defines state" do
        expect(test_class.states).to include(:standing)
      end
    end

    context "define initial state" do
      subject { test_class.new }

      before { test_class.state :standing, initial: true }

      it "set state as initial" do
        expect(subject.state).to eq(:standing)
      end
    end

    context "define initial state twice" do
      before { test_class.state :standing, initial: true }

      it "raises an exception" do
        expect { test_class.state :walking, initial: true }
          .to raise_error(StateMachine::State::InitialStateAlreadyDefined)
      end
    end

    context "define the same state two times" do
      it "raises an exception" do
        expect { 2.times { test_class.state :standing } }
          .to raise_error(StateMachine::State::DoubleStateDefinition)
      end
    end
  end

  context ".{state}?" do
    before do
      test_class.state :standing, initial: true
      test_class.state :walking
    end

    context "check currently state" do
      it "returns true" do
        expect(test_class.new.standing?).to be_truthy
      end
    end

    context "check other state" do
      it "returns false" do
        expect(test_class.new.walking?).to be_falsey
      end
    end

    context "non exisited state" do
      it "raises an error" do
        expect { test_class.new.running? }.to raise_error(NoMethodError)
      end
    end
  end
end
