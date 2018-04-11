require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

ENV['CAPYBARA_DRIVER'] = 'selenium'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color --format documentation'
end

task :prepare_sauce do
  sc =
    case RUBY_PLATFORM
    when /cygwin|mswin|mingw|bccwin|wince|emx/ then 'sc-windows.exe'
    when /darwin/ then 'sc-osx'
    else 'sc-linux'
    end

    FileUtils.cp("vendor/sauce/#{sc}", 'vendor/sauce/sc')
end

task :default => [:spec]
