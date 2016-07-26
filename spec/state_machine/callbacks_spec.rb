require 'spec_helper'

RSpec.describe "StateMachine callbacks" do
  subject { test_class.new }

  let(:test_class) do
    Class.new do
      include StateMachine

      state :standing, initial: true
      state :walking
      state :running

      event :walk do
        transitions from: :standing, to: :walking
      end

      event :run do
        transitions from: :walking, to: :running
      end

      def enter_walking
      end

      def leave_walking
      end

      def before_walk
      end

      def after_walk
      end
    end
  end

  context "transitions callbacks" do
    it "executes before callback" do
      expect(subject).to receive(:before_walk)

      subject.walk!
    end

    it "executes after callback" do
      expect(subject).to receive(:after_walk)

      subject.walk!
    end
  end

  context "state callbacks" do
    it "executes enter state callback" do
      expect(subject).to receive(:enter_walking)

      subject.walk!
    end

    it "executes leave state callback" do
      expect(subject).to receive(:leave_walking)

      subject.walk!
      subject.run!
    end
  end
end
