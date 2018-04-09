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
