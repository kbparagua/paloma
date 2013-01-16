require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/*_spec.rb']
end


desc "Run all tests"
task :test do
  sh "bundle exec rake spec"
end


desc "Run callback tests"
task :test_callbacks do
  sh "rspec ./spec/callback_spec.rb"
end


desc "Run generator tests"
task :test_generators do
  sh "rspec ./spec/generator_spec.rb"
end

