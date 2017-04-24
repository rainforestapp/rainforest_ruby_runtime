require_relative './test_helper'

module RainforestRubyRuntime
  describe Runner do
    subject { Runner.new }
    let(:code) { read_sample "empty" }
    
    describe "#session_id" do
      it "returns a session id" do
        subject.stub(:current_driver, OpenStruct.new(browser: OpenStruct.new(session_id: 'session'))) do
          subject.session_id.must_equal 'session' 
        end
      end
    end

    describe "#run" do
      describe "with a limited browser set" do
        subject { Runner.new browsers: %w(chrome) }

        it "applies the correct configuration" do
          subject.stub(:driver, 'sauce') do
            subject.run(code)
            Sauce.get_config.browsers.must_equal [["Windows 7", "Chrome", "35"]]
          end
        end
      end

      describe "for a rainforest test" do
        let(:code) { read_sample "simple" }

        it "runs the content of the step" do
          test = subject.run(code)
          test.must_be_instance_of(Test)
          $simple_test_was.must_equal :run
        end
      end

      describe "for another type of test" do
        it "raises an exception" do
          -> do
            subject.run("")
          end.must_raise(WrongReturnValueError)
        end
      end

      describe "with custom step variables" do
        let(:code) { read_sample "step_variables" }

        it "makes the variable accessible in the test" do
          subject.run(code)
          $step_variable_1_was.wont_be_nil
          $step_variable_2_was.must_match(/time is: .*/)
          $step_variable_3_was.must_equal("1")
        end
      end
    end

    describe "#extract_results" do
      subject { Runner.new.extract_results(code, fake_session_id: :test) }

      describe "a failing spec" do
        let(:code) { format_step "expect(1).to eq(2)" }
        it "catches failled rspec assertions" do
          subject[:message].must_include "expected: 2"
          subject[:status].must_equal "failed"
        end
      end

      describe "select capybara error" do
        let(:code) { format_step "raise Capybara::ElementNotFound" }
        it "catches failled rspec assertions" do
          subject[:status].must_equal "failed"
        end
      end

      describe "a passing spec" do
        let(:code) { format_step "expect(1).to eq(1)" }
        it "returns a 'passed'" do
          subject[:status].must_equal "passed"
        end
      end

      describe "a spec raising a runtime error" do
        let(:code) { format_step "raise 'foo'" }
        it "returns an 'error'" do
          subject[:status].must_equal "error"
        end
      end

      describe "a spec raising a selenium error" do
        let(:code) { format_step "raise Selenium::WebDriver::Error::WebDriverError" }
        it "returns an 'error'" do
          subject[:status].must_equal "error"
        end
      end

      describe "a spec with syntax error" do
        let(:code) { format_step "if if true; puts true; end;" }
        it "returns an 'fatal_error'" do
          subject[:status].must_equal "fatal_error"
        end
      end

      describe "a tests that outputs to stdout" do
        let(:code) { format_step "print 'hello'" }
        it "captures it and adds it to the payload" do
          subject[:stdout].must_equal "hello"
        end
      end

      describe "a tests that errputs to stderr" do
        let(:code) { format_step "$stderr.print 'hello'" }
        it "captures it and adds it to the payload" do
          subject[:stderr].must_equal "hello"
        end
      end

      describe "a test with predefined values for custom variables" do
        let(:code) { read_sample "step_variables" }
        let(:step_variables) do
          {
            "my_custom_scope" => {
              "uuid" => "some_uuid",
              "time" => "some_time",
            },
            "my_other_scope" => {
              "constant" => "some_constant",
            }
          }
        end
        let(:runner) { Runner.new(step_variables: step_variables) }

        subject do
          runner.extract_results(code, fake_session_id: :test)
        end

        it "uses the passed in variables" do
          subject[:status].must_equal "passed"
          $step_variable_1_was.must_equal "some_uuid"
          $step_variable_2_was.must_equal "some_time"
          $step_variable_3_was.must_equal "some_constant"
        end
      end
    end

    describe "callbacks" do
      let(:callback) do
        Class.new do
          attr_reader :before_steps, :before_tests, :after_steps, :after_tests

          def initialize
            @before_steps = []
            @after_steps = []
            @after_tests = []
            @before_tests = []
          end

          def before_step(step)
            @before_steps << step
          end

          def after_step(step)
            @after_steps << step
          end

          def after_test(test)
            @after_tests << test
          end

          def before_test(test)
            @before_tests << test
          end
        end.new
      end

      let(:code) { read_sample "two_steps" }
      subject { Runner.new callback: callback }

      it "calls the right method on the callback object" do
        subject.run(code)
        callback.before_tests.size.must_equal 1
        callback.after_tests.size.must_equal 1
        callback.before_steps.size.must_equal 2
        callback.after_steps.size.must_equal 2

        callback.before_steps.map(&:id).must_equal [1, 2]
        callback.after_steps.map(&:id).must_equal [1, 2]

        callback.before_steps.map(&:action).must_equal ["action 1", "action 2"]
      end

      describe "a partially define callback object" do
        let(:callback) do
          Class.new do
          end.new
        end

        it "should not rise a method missing exception" do
          subject.run(code)
        end
      end
    end

    def read_sample(name)
      File.read(File.expand_path("../sample_tests/#{name}.rb", __dir__))
    end

    def format_step(code)
      read_sample("one_step").gsub("#REPLACE", code)
    end
  end
end
