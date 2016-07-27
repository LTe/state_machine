require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'graphviz'
require 'state_machine'
require './examples/example'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['-fd -c --order random']
  spec.pattern = FileList['spec/**/*_spec.rb']
end

def graphviz(machine)
  graphviz = GraphViz.new(:G, type: :digraph)
  states   = {}

  machine.states.each { |state| states[state] = graphviz.add_nodes(state.to_s) }

  transitions = machine.possible_transitions.values

  transitions.each do |transition|
    transition.keys.each do |to|
      transition.values.flatten.each do |from|
        graphviz.add_edges(states[from], states[to])
      end
    end
  end

  graphviz.output(png: "states.png")
  `open states.png`
end

desc "Generate states graph"
task :graphviz do
  graphviz(Example)
end

task default: [:rubocop, :spec]
