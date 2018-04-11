require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'fileutils'
require 'open-uri'

GITHUB_REPO = 'https://raw.githubusercontent.com/rainforestapp/rainforest_ruby_runtime'

RSpec::Core::RakeTask.new(:spec) do |t|
  ENV['CAPYBARA_DRIVER'] = 'selenium'
  t.rspec_opts = '--color --format documentation'
end

task :prepare_sauce do
  sc =
    case RUBY_PLATFORM
    when /cygwin|mswin|mingw|bccwin|wince|emx/ then 'sc-windows.exe'
    when /darwin/ then 'sc-osx'
    else 'sc-linux'
    end

  FileUtils.mkdir_p('vendor/sauce')
  url = "#{GITHUB_REPO}/v#{RainforestRubyRuntime::VERSION}/vendor/sauce/#{sc}"

  File.open('vendor/sauce/sc', 'wb') do |file|
    IO.copy_stream(open(url), file)
    file.chmod(0755)
  end
end

task :default => [:spec]
