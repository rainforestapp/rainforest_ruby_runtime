require_relative './test_helper'

module RainforestRubyRuntime
  describe Runner do
    subject { Runner.new }

    describe "#run" do
      it "runs the code and return the results" do
        subject.run(":expected").must_equal :expected
      end

      describe "with a limited browser set" do
        subject { Runner.new browsers: %w(chrome) }

        it "applies the correct configuration" do
          subject.stub(:driver, 'sauce') do
            subject.run("code")
            Sauce.get_config.browsers.must_equal [["Windows 7", "Chrome", "35"]]
          end
        end
      end
    end

    describe "#extract_results" do
      subject { Runner.new.extract_results(code) }

      describe "a failing spec" do
        let(:code) { "expect(1).to eq(2)" }
        it "catches failled rspec assertions" do
          subject[:message].must_include "expected: 2"
          subject[:status].must_equal "failed"
        end
      end

      describe "a passing spec" do
        let(:code) { "expect(1).to eq(1)" }
        it "returns a 'passed'" do
          subject[:status].must_equal "passed"
        end
      end

      describe "a spec raising a runtime error" do
        let(:code) { "raise 'foo'" }
        it "returns an 'error'" do
          subject[:status].must_equal "error"
        end
      end

      describe "a spec with syntax error" do
        let(:code) { "if if true; puts true; end;" }
        it "returns an 'fatal_error'" do
          subject[:status].must_equal "fatal_error"
        end
      end
    end
  end
end
