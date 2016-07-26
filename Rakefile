require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'graphviz'
require 'state_machine'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['-fd -c --order random']
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Generate states graph"
task :graphviz do
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

  g      = GraphViz.new(:G, :type => :digraph)
  states = {}

  Example.states.each { |state| states[state] = g.add_nodes(state.to_s) }

  transitions = Example.possible_transitions.values

  transitions.each do |transition|
    transition.keys.each do |to|
      transition.values.flatten.each do |from|
        g.add_edges(states[from], states[to])
      end
    end
  end

  g.output( :png => "states.png" )
  `open states.png`
end

task default: [:rubocop, :spec]
