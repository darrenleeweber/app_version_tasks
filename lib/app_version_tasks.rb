require 'app_version_tasks/version'
require 'app_version_tasks/configuration'
require 'app_version_tasks/semantic_version'

# Manage and release application semantic versions
module AppVersionTasks
  # Configuration at the module level
  class << self
    attr_reader :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
