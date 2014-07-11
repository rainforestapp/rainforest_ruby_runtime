require_relative './test_helper'

module RainforestRubyRuntime
  describe Runner do
    describe ".run" do
      it "runs the code and return the results" do
        Runner.run(":expected").must_equal :expected
      end
    end

    describe ".extract_results" do
      subject { Runner.extract_results(code) }

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
    end
  end
end
