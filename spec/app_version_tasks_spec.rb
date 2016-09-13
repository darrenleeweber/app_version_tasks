require 'spec_helper'

describe AppVersionTasks do
  context 'module configuration' do
    let(:config) { described_class.configuration }

    describe '.configuration' do
      it 'is a configuration object' do
        expect(config).to be_an described_class::Configuration
      end
    end

    describe '.configure' do
      specify do
        expect { |b| described_class.configure(&b) }.to yield_control
      end

      specify do
        expect { |b| described_class.configure(&b) }.to yield_with_args(config)
      end
    end

    describe '.reset' do
      it 'resets the configuration' do
        config = described_class.configuration
        app_name = 'MyApp'
        config.application_name = app_name
        expect(config.application_name).to eq(app_name)
        described_class.reset
        config = described_class.configuration
        expect(config.application_name).to be Rails.application.class.parent_name
      end
    end
  end
end
