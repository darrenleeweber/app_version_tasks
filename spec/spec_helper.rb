require 'bundler/setup'
Bundler.setup

require 'single_cov'
SingleCov.setup :rspec

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'simplecov'
SimpleCov.profiles.define 'app_version_tasks' do
  add_filter '.gems'
  add_filter 'pkg'
  add_filter 'spec'
  # Simplecov can detect changes using data from the
  # last rspec run.  Travis will never have a previous
  # dataset for comparison, so it can't fail a travis build.
  maximum_coverage_drop 0.1
end
SimpleCov.start 'app_version_tasks'

require 'app_version_tasks'

# If you're using all parts of Rails:
require 'combustion'
Combustion.initialize! :all
# Or, load just what you need:
# Combustion.initialize! :active_record, :action_controller

require 'pry'
require 'rspec'
require 'rspec/rails'

GIT_ORIGIN_PATH = Dir.mktmpdir

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.before :suite do
    Git.init(GIT_ORIGIN_PATH, bare: true)
    APP_GIT = Git.open File.join(Dir.pwd, 'spec', 'internal')
    APP_GIT.remotes.each { |remote| APP_GIT.remove_remote remote }
    APP_GIT.add_remote 'origin', GIT_ORIGIN_PATH
    APP_GIT.push('origin', 'master')
  end

  config.after :suite do
    APP_GIT.remotes.each { |remote| APP_GIT.remove_remote remote }
    FileUtils.rm_r GIT_ORIGIN_PATH, secure: true
  end
end
