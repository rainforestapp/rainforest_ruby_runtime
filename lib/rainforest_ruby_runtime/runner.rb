module RainforestRubyRuntime
  class Runner
    attr_reader :config_options, :logger

    FAILURE_EXCEPTIONS = [
      RSpec::Expectations::ExpectationNotMetError,
      Capybara::ElementNotFound,
    ].freeze

    def initialize(options = {})
      @config_options = options.dup.freeze
      @step_variables = options[:step_variables]
      @callback = NilDelegator.new(options.fetch(:callback) { Empty.new })
      @logger = options.fetch(:logger) { Logger.new(StringIO.new) }
    end

    def run(code)
      logger.debug "Running code:\n#{code}\nDriver: #{driver}"
      Capybara.default_driver = :"#{driver}"
      Capybara.default_max_wait_time = wait_time

      apply_config!
      setup_scope_registery!

      dsl = RainforestRubyRuntime::DSL.new(callback: @callback)

      test = dsl.run_code(code)
      if Test === test
        run_test(test)
      else
        raise WrongReturnValueError, test
      end
      test
    ensure
      terminate_session!
    end

    def run_test(test)
      sauce = driver == 'sauce'
      describe = RSpec.describe 'Rainforest', sauce: sauce, tests: [test] do
        metadata[:tests].each do |test|
          it "[#{test.id}] #{test.title}" do
            test.run
          end
        end
      end

      RSpec.configuration.reporter.report(RSpec.world.example_count([describe])) do |reporter|
        describe.run(reporter)
      end
    end

    def driver
      ENV.fetch("CAPYBARA_DRIVER") { "selenium" }
    end

    def current_browser
      current_driver.browser
    end

    def session_id
      current_browser.session_id if current_driver.browser.respond_to?(:session_id)
    rescue Selenium::WebDriver::Error::WebDriverError => e
      logger.error "Can't retrieve session id"
      logger.error "#{e.class} #{e.message}\n#{e.backtrace.join("\n")}"
      nil
    end

    private
    def exception_to_payload(e, payload = {})
      payload.merge({
        exception: e.class.to_s,
        message: e.message,
        backtrace: e.backtrace,
      })
    end

    def apply_config!
      config = {
        "selenium" => Drivers::Selenium,
        "sauce" => Drivers::Sauce,
      }.fetch(driver)

      config.new(config_options).call
    end

    def current_driver
      Capybara.current_session.driver
    end

    def terminate_session!
      # Terminate the Sauce session if needed
      if current_driver.respond_to?(:finish!)
        current_driver.finish!
      elsif current_driver.respond_to?(:quit)
        current_driver.quit
      else
        logger.warn "Cannot terminate session. Driver #{driver}" and return
      end
      logger.debug "Session successfuly terminated"
    rescue Selenium::WebDriver::Error::WebDriverError => e
      # Ignore
      logger.warn "Exception while terminating session. Driver #{driver}. Class: #{e.class}"
      logger.warn "#{e.message}\n#{e.backtrace.join("\n")}"
    end

    def wait_time
      ENV.fetch("CAPYBARA_WAIT_TIME", 20).to_i
    end

    def setup_scope_registery!
      # TODO this should not be set globally, but passed in the DSL
      if @step_variables.nil?
        Variables.scope_registery = Variables::Registery.new
      else
        Variables.scope_registery = Variables::StaticVariableRegistery.new(@step_variables)
      end
    end
  end
end
