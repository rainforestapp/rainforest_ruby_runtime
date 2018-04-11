require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

ENV['CAPYBARA_DRIVER'] = 'selenium'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color --format documentation'
end

task :default => [:spec]
