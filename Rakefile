require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['-fd -c --order random']
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task default: [:rubocop, :spec]
