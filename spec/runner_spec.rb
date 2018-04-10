require_relative './spec_helper'

module RainforestRubyRuntime
  describe Runner do
    let(:code) { read_sample "empty" }

    subject { Runner.new(browsers: %i(chrome)) }

    before do
      allow(subject).to receive(:driver).and_return('selenium')
    end

    describe "#session_id" do
      before { allow(subject).to receive(:current_driver) { OpenStruct.new(browser: OpenStruct.new(session_id: 'session')) } }

      it "returns a session id" do
        expect(subject.session_id).to eq('session')
      end
    end

    describe "#run" do
      describe "with a limited browser set" do
        before do
          allow(subject).to receive(:driver_type).and_return('sauce')
          expect_any_instance_of(Drivers::Sauce).to receive(:to_rspec) do |driver|
            driver.send(:apply_config)
            double(run: nil)
          end
        end

        it "applies the correct configuration" do
          subject.run(code)
          expect(Sauce.get_config.browsers).to eq([['Windows 7', 'Chrome', 'latest']])
        end
      end

      describe "for a rainforest test" do
        let(:code) { read_sample "simple" }

        it "runs the content of the step" do
          test = subject.run(code)
          expect(test).to be_instance_of(Test)
          expect($simple_test_was).to eq(:run)
          expect receive(:run_test).with(test)
        end
      end

      describe "for another type of test" do
        it "raises an exception" do
          expect { subject.run('') }.to raise_error(WrongReturnValueError)
        end
      end

      describe "with custom step variables" do
        let(:code) { read_sample "step_variables" }

        it "makes the variable accessible in the test" do
          subject.run(code)
          expect($step_variable_1_was).to_not be_nil
          expect($step_variable_2_was).to match(/time is: .*/)
          expect($step_variable_3_was).to eq('1')
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

      subject { Runner.new(browsers: %i(chrome), callback: callback) }

      it "calls the right method on the callback object" do
        subject.run(code)
        expect(callback.before_tests.size).to eq(1)
        expect(callback.after_tests.size).to eq(1)
        expect(callback.before_steps.size).to eq(2)
        expect(callback.after_steps.size).to eq(2)

        expect(callback.before_steps.map(&:id)).to eq([1, 2])
        expect(callback.after_steps.map(&:id)).to eq([1, 2])

        expect(callback.before_steps.map(&:action)).to eq(["action 1", "action 2"])
      end

      describe "a partially define callback object" do
        let(:callback) do
          Class.new do
          end.new
        end

        it "should not raise a method missing exception" do
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
