require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'
  ENV['CAPYBARA_DRIVER'] = 'selenium'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '--color --format documentation'
  end
rescue LoadError
  # No RSpec
end

task :default => [:spec]
