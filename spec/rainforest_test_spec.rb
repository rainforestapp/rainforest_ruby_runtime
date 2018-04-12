require 'open3'
require_relative './spec_helper'

module RainforestRubyRuntime
  describe 'rainforest_test', show_output: true do
    subject do
      if browsers
        Open3.capture2e("ruby bin/rainforest_test #{browsers} sample_tests/empty.rb")
      else
        Open3.capture2e('ruby bin/rainforest_test sample_tests/empty.rb')
      end
    end

    context 'with no browsers' do
      let(:browsers) { nil }

      it 'defaults to chrome' do
        output, status = subject

        expect(status).to be_success
        expect(output).to match(/chrome/)
      end
    end

    context 'with a browser' do
      context 'from the whitelist' do
        let(:browser) { Runner::BROWSERS.sample }
        let(:browsers) { "--browsers #{browser}" }

        it 'passes it to Runner' do
          output, status = subject

          expect(status).to be_success
          expect(output).to match(browser)
        end
      end

      context 'that is unknown' do
        let(:browsers) { "--browsers opera" }

        it 'exits with status 1' do
          output, status = subject

          expect(status).to_not be_success
          expect(output).to match(/invalid option: #{browsers}/)
        end
      end
    end

    context 'with multiple browsers' do
      context 'from the whitelist' do
        let(:browser_values) { Runner::BROWSERS.sample(2) }
        let(:browsers) { "--browsers #{browser_values.join(',')}" }

        it 'passes them to Runner' do
          output, status = subject

          expect(status).to be_success
          browser_values.each { |b| expect(output).to match(b) }
        end
      end

      context 'that is unknown' do
        let(:browsers) { "--browsers #{Runner::BROWSERS.sample},opera" }

        it 'exits with status 1' do
          output, status = subject

          expect(status).to_not be_success
          expect(output).to match(/invalid option: --browsers opera/)
        end
      end
    end

    context 'with multiple files' do
      subject do
        Open3.capture2e('ruby bin/rainforest_test sample_tests/empty.rb sample_tests/simple.rb')
      end

      it 'should work' do
        output, status = subject

        expect(status).to be_success
        expect(output).to match(/\[1\] empty/)
        expect(output).to match(/\[1\] My Sample Test/)
      end
    end
  end
end
