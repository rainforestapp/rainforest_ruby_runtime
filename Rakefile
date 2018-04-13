require 'bundler/gem_tasks'
require 'rainforest_ruby_runtime'
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
    case RainforestRubyRuntime.platform
    when :windows then 'sc-windows.exe'
    when :osx then 'sc-osx'
    else 'sc-linux'
    end


  FileUtils.mkdir_p('vendor/sauce')
  url = "#{GITHUB_REPO}/v#{RainforestRubyRuntime::VERSION}/vendor/sauce/#{sc}"

  File.open(RainforestRubyRuntime.sc_executable_path, 'wb') do |file|
    IO.copy_stream(open(url), file)
    file.chmod(0755)
  end
end

task :default => [:spec]
