require 'spec_helper'

describe AppVersionTasks::Configuration do
  before :each do
    AppVersionTasks.reset
  end

  let(:config) { described_class.new }

  let(:root_path) { config.send(:default_root_path) }

  describe '#new' do
    it 'works' do
      opts = {}
      result = AppVersionTasks::Configuration.new(opts)
      expect(result).to be_an described_class
    end
  end

  describe '#application_name' do
    it 'works' do
      expect(config.application_name).to be_an String
    end
    it 'defaults to rails application name' do
      app_name = Rails.application.class.parent_name
      expect(config.application_name).to eq(app_name)
    end
    it 'falls back to "App"' do
      allow(Rails).to receive(:application).and_raise('oops')
      expect(config.application_name).to eq('App')
    end
  end

  describe '#application_name=' do
    it 'sets the #application_name' do
      value = 'AppName'
      config.application_name = value
      expect(config.application_name).to eq value
    end
  end

  describe '#git_working_directory' do
    it 'default value is default_root_path' do
      expect(config.git_working_directory).to eq(root_path)
    end
  end

  describe '#git_working_directory=' do
    it 'can set value' do
      path = Dir.pwd
      config.git_working_directory = path
      expect(config.git_working_directory).to eq(path)
    end
  end

  describe '#version_file_path' do
    it 'default value is {default_root_path}/config/version.rb' do
      path = File.join(root_path, 'config', 'version.rb')
      expect(config.version_file_path).to eq(path)
    end
  end

  describe '#version_file_path=' do
    it 'can set value' do
      path = 'version.rb'
      config.version_file_path = path
      expect(config.version_file_path).to eq(path)
    end
  end
end
